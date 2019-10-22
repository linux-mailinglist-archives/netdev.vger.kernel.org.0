Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6718DFC78
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 06:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbfJVEO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 00:14:29 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43674 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbfJVEO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 00:14:29 -0400
Received: by mail-pf1-f195.google.com with SMTP id a2so9787958pfo.10
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 21:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=cAirh7fAdCvjf+X1rkp8UgESCy69nPiPSbWZyN2AfTM=;
        b=H2srs1fKirGV+izTKxlbFUTNVcnLsrNVpOPBf4tQTTggn1DV01E5fcz1eBs27weuH8
         mT9tgvBGFxpR+fvQZ61g3y8EaqEdAAHpHTCL9ckCJ6Q8sjAP/pxwSDatwiCL6N/wcM9T
         T1v0QpW4TduLNII+IBB3zweaRuPyo2UyWcfP/70M0/4W3hAV5EaY3hrvpelY7P96vtUl
         /UTWLR9JLlH4j8EWpEVeiKPFmIydemn5hFnvT+dWQdiTXG07DiPbGKcYNMXRMMoDnsB/
         XEjU3uOq/5r/dmM/IbQD07t+JCnTYEHdX8ji5XlduDZ4P8SZ9b5TkpYMCyNMD2v+PTwp
         xZ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=cAirh7fAdCvjf+X1rkp8UgESCy69nPiPSbWZyN2AfTM=;
        b=RL9UT097+OcQSoYllOjQBPzG98S5M3WG4XnE4vB+xq8qSZWZO/re0M1BYOAmRO4Lst
         Yk44KRpVNik4R5miHEtqhP0QdOna0eZCFR92QHD5gvcYllnqeYeVmhUaaO8l10WGbX5A
         IGOVdwp60U7WDc60ndrye6h4Yev7nqKlsjy8BFRmKW6i7LgLNdtkKft1cH+K6V4fUFe6
         xnFoa9ONnhLIYxxeRrFmVDpRokuqM4zucmKyEZWOqGUQjOe3uLANj/mpE4dXQu7bPj9C
         SZJc6sV4pqxkZxv2lw0DL34bdf8/IcveZ4m+T+kdWXIIjzZsGwAJjr9TvMUxxtmstMzL
         N8Ow==
X-Gm-Message-State: APjAAAX0Ksv1OckuBNedce+/ZritlM8te0+cM5KR3WT821Q3/W2R+WOd
        3v7T3f804yBfMiFiALROTzDuRw==
X-Google-Smtp-Source: APXvYqy0+YxwKwksw1LWBaLYDcFsdrqcIGrip+kHpfexSNpN/BpfzzMngO8ZUqXNW4jDQlTnD1W3fA==
X-Received: by 2002:a62:60c7:: with SMTP id u190mr1775017pfb.256.1571717668377;
        Mon, 21 Oct 2019 21:14:28 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id x9sm22966397pje.27.2019.10.21.21.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 21:14:28 -0700 (PDT)
Date:   Mon, 21 Oct 2019 21:14:25 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        vasundhara-v.volam@broadcom.com, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net 2/5] bnxt_en: Fix devlink NVRAM related byte order
 related issues.
Message-ID: <20191021211425.242beb0e@cakuba.netronome.com>
In-Reply-To: <1571636069-14179-3-git-send-email-michael.chan@broadcom.com>
References: <1571636069-14179-1-git-send-email-michael.chan@broadcom.com>
        <1571636069-14179-3-git-send-email-michael.chan@broadcom.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 01:34:26 -0400, Michael Chan wrote:
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/=
net/ethernet/broadcom/bnxt/bnxt_devlink.c
> index 68f74f5..bd4b9f3 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> @@ -226,12 +226,55 @@ static const struct bnxt_dl_nvm_param nvm_params[] =
=3D {
>  	 BNXT_NVM_SHARED_CFG, 1, 1},
>  };
> =20
> +union bnxt_nvm_data {
> +	u8	val8;
> +	__le32	val32;
> +};
> +
> +static void bnxt_copy_to_nvm_data(union bnxt_nvm_data *dst,
> +				  union devlink_param_value *src,
> +				  int nvm_num_bits, int dl_num_bytes)
> +{
> +	u32 val32 =3D 0;
> +
> +	if (nvm_num_bits =3D=3D 1) {
> +		dst->val8 =3D src->vbool;
> +		return;
> +	}

Why do you special case the num_bits =3D=3D 1? If val32 is __le32 the low
byte would have landed on the first byte anyway, no? =F0=9F=A4=94

just curious

> +	if (dl_num_bytes =3D=3D 4)
> +		val32 =3D src->vu32;
> +	else if (dl_num_bytes =3D=3D 2)
> +		val32 =3D (u32)src->vu16;
> +	else if (dl_num_bytes =3D=3D 1)
> +		val32 =3D (u32)src->vu8;
> +	dst->val32 =3D cpu_to_le32(val32);
> +}
