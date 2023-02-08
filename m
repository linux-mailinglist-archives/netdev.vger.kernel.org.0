Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFEE68F23A
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 16:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbjBHPlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 10:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjBHPlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 10:41:18 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FEE48A08;
        Wed,  8 Feb 2023 07:41:17 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id y4so943507pfe.4;
        Wed, 08 Feb 2023 07:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ve+9b2Qi4QH55+IMknZLZqZvNPVOjzseuDH+jH0F2bw=;
        b=nFZZf8nrA50gOQ72uyOrle9KCurosMmlUpiG0iNBwvVzo0CJNEqBsFR9mwYqo+vT5q
         13SDT6AEY9ijHCTLwswiCL9N8iwESh/qNheiBTyDj9OTabF/UL5+kuoU2l9Obgg+Sbfk
         dYoqKqou8dNgiEIlwQ8TrzQtZ2DJjPvotNTxyd/SfYwh/Xx9gEut7Gpc7jJ6KpEfNV68
         zdtULC+NovJxCq8N287T9+kkTlZPElZcfsH9IRjMNBlDdn4+m1sHY35q4pSuxvQZO00m
         T9lAlEpDRU9g7DpqpeEq0kKfNhI3kKW0qE/xFVa435Rxho/6JHg2/vUhs2bq91jecRdS
         JamA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ve+9b2Qi4QH55+IMknZLZqZvNPVOjzseuDH+jH0F2bw=;
        b=Uh6q2pE6KA+j2RVjKcMzoxsZ1TuNL0+5KXB4Ll08/nOOIU/vV6miUM5L3BZmf7OrhE
         tLv1Nl1AnQWlsYbCxZp5uuTajDbECRzcb8NOGX+vF7JmKauImqsDgBwBc4ArBXX6zpmS
         MoR8Xbmzbmw9ieBE4yv2ZlrxJmwMUcQs4KBvh3MqRIznY4qT2chScBfiv4lRjRSnq6i7
         CP2+Nr1GdybNSoEonCIMdr4tyjeviF3rmhKMkHdzY/hv55qgr+Qu1/E4EWeJUAq7nn9F
         jvGgsO9KV7OSoscC6C01DdHfQZPLPTWpVuQTJE6h7cRp0VgCoVRXStSPfdljvot1DBqV
         gZVA==
X-Gm-Message-State: AO0yUKWUzd8U+YAFrHViMrEjrfyBCKRqLBe/i0VpccqHtYuBbWnYXG4t
        vuAmnx1zEiPb+8ZIFP+bOlk=
X-Google-Smtp-Source: AK7set9UTWY6Rr3Hk/2ig1fM62OTMBVuuEEnv8lQWsr64vq7cs1K+rvyb9/y3awDxGi46NxWBdhMgQ==
X-Received: by 2002:a62:4e48:0:b0:5a7:a688:cd8a with SMTP id c69-20020a624e48000000b005a7a688cd8amr5546379pfb.33.1675870877091;
        Wed, 08 Feb 2023 07:41:17 -0800 (PST)
Received: from [192.168.0.128] ([98.97.119.54])
        by smtp.googlemail.com with ESMTPSA id 187-20020a6217c4000000b005825b8e0540sm11359357pfx.204.2023.02.08.07.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 07:41:16 -0800 (PST)
Message-ID: <c33e26364b18039e3632218d8e2a76f3b6a08577.camel@gmail.com>
Subject: Re: [PATCH net v2 2/3] i40e: add double of VLAN header when
 computing the max MTU
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Jason Xing <kerneljasonxing@gmail.com>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        richardcochran@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        alexandr.lobakin@intel.com, maciej.fijalkowski@intel.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Date:   Wed, 08 Feb 2023 07:41:14 -0800
In-Reply-To: <20230208024333.10465-2-kerneljasonxing@gmail.com>
References: <20230208024333.10465-1-kerneljasonxing@gmail.com>
         <20230208024333.10465-2-kerneljasonxing@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-02-08 at 10:43 +0800, Jason Xing wrote:
> From: Jason Xing <kernelxing@tencent.com>
>=20
> Include the second VLAN HLEN into account when computing the maximum
> MTU size as other drivers do.
>=20
> Fixes: 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")
> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> ---
> v2: drop the duplicate definition
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/et=
hernet/intel/i40e/i40e_main.c
> index 53d0083e35da..d039928f3646 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -2921,7 +2921,7 @@ static int i40e_change_mtu(struct net_device *netde=
v, int new_mtu)
>  	struct i40e_pf *pf =3D vsi->back;
> =20
>  	if (i40e_enabled_xdp_vsi(vsi)) {
> -		int frame_size =3D new_mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
> +		int frame_size =3D new_mtu + I40E_PACKET_HDR_PAD;
> =20
>  		if (frame_size > i40e_max_xdp_frame_size(vsi))
>  			return -EINVAL;

Looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
