Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4BA690224
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 09:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjBII14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 03:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjBII1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 03:27:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFBC5268
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 00:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675931223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KeiSB4E2wYbQhav/hjow4P+1HmnIHm/QNzDHo+ov7jQ=;
        b=RHR3oAzWUnhcsdWnDScsMK4HGOwo8qyqzr2B+SCwWqGf6MM4OqqSYWSvcSevXlM2Diapmi
        eMqbjdMoMl2cNl+qrVjlDMz5DoR1yQwRFFbOUsv3fnWvQ/v3+OSbye7aqhTDAl4geOdp4s
        nPvlHfbq1pcQyx0UzyMnCCcLEr47YHI=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-434-WSZnQ6LTOum5Ks8VaDl1Dw-1; Thu, 09 Feb 2023 03:27:02 -0500
X-MC-Unique: WSZnQ6LTOum5Ks8VaDl1Dw-1
Received: by mail-ej1-f69.google.com with SMTP id lf9-20020a170907174900b0087861282038so1038785ejc.6
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 00:27:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KeiSB4E2wYbQhav/hjow4P+1HmnIHm/QNzDHo+ov7jQ=;
        b=o5tl09gIWtw8TaKFsE2Cpji0ke+4hAlhDdR68cEgun9dNbP5WdVf0GJ+P+y/WzMqms
         HnsgF6Nvf1uPbpkhP7UN6qntuy1f4z5bxb8ADh6Xkr8Mrt1WtFlsxPRKLOeQ50nlYZzu
         wrBJQmRhgY3G6YOjVjex8R7DwYNGcg0QdZd838QjiOEK35DlzWsueOJ3conj72qzWfni
         7HFqNjxHOFXPuEGKn0nvsPiLXMIZmA+P3g7Bjmca90LMpixmIMXyJ10OHwPfe6wsxD7C
         /Q8NvS128ScvDQKItetOrIofmynO3zBcWLnc+12szyxWHlFfGjg025YNh74O4849GT1E
         7pWQ==
X-Gm-Message-State: AO0yUKVu08T2UicNX27KIn2OmpADguLD9n5qXj0gOo+cqFZBTG0NAnwd
        PR1Q3TjDBGpKKx4Ce9eiZIgkUf+XD4VuRqKrqoGpzVs5ps2zlcEWBcw6Nj+8JQYYO8J+VcsV6oo
        WEpZCdiXwQlknPBbX
X-Received: by 2002:a17:906:914:b0:877:a2d1:7560 with SMTP id i20-20020a170906091400b00877a2d17560mr11064805ejd.27.1675931220903;
        Thu, 09 Feb 2023 00:27:00 -0800 (PST)
X-Google-Smtp-Source: AK7set+HVTK1AiBbk6GMlw7ohCG7wgotU2j7N1VXPH5fSQyaI8DSS3LYxlt8FWr629Ks1eOmHgrk6g==
X-Received: by 2002:a17:906:914:b0:877:a2d1:7560 with SMTP id i20-20020a170906091400b00877a2d17560mr11064795ejd.27.1675931220679;
        Thu, 09 Feb 2023 00:27:00 -0800 (PST)
Received: from [10.39.193.13] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id i16-20020a170906699000b00883410a786csm552562ejr.207.2023.02.09.00.26.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Feb 2023 00:27:00 -0800 (PST)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     pshelar@ovn.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, xiangxia.m.yue@gmail.com,
        netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: openvswitch: fix possible memory leak in
 ovs_meter_cmd_set()
Date:   Thu, 09 Feb 2023 09:26:59 +0100
X-Mailer: MailMate (1.14r5942)
Message-ID: <155E8FC1-746B-4BA4-BA80-60868B076F00@redhat.com>
In-Reply-To: <20230208071623.13013-1-hbh25y@gmail.com>
References: <20230208071623.13013-1-hbh25y@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8 Feb 2023, at 8:16, Hangyu Hua wrote:

> old_meter needs to be free after it is detached regardless of whether
> the new meter is successfully attached.
>
> Fixes: c7c4c44c9a95 ("net: openvswitch: expand the meters supported num=
ber")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
>  net/openvswitch/meter.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
> index 6e38f68f88c2..e84082e209e9 100644
> --- a/net/openvswitch/meter.c
> +++ b/net/openvswitch/meter.c
> @@ -448,8 +448,10 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, =
struct genl_info *info)
>  		goto exit_unlock;
>
>  	err =3D attach_meter(meter_tbl, meter);
> -	if (err)
> +	if (err) {
> +		ovs_meter_free(old_meter);
>  		goto exit_unlock;

It would be nicer to add another goto label like exit_free_old_meter.

+	if (err)
+     	goto exit_free_old_meter:

exit_free_old_meter:
    ovs_meter_free(old_meter);
exit_unlock:
	ovs_unlock();
	nlmsg_free(reply);
exit_free_meter:


Or maybe it would be even nicer to free the old_meter outside of the glob=
al lock?

> +	}
>
>  	ovs_unlock();
>
> -- =

> 2.34.1

