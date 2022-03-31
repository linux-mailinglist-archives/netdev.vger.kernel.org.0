Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0B0A4ED59C
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 10:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbiCaIaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 04:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232848AbiCaIaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 04:30:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9E33B1CAF10
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 01:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648715298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yWnBV75IVBvHsDRdv1eIvwYgM5PPl5byFU3eX43vCM0=;
        b=cmUbGlEatpdjVW/kRimymZoPR2VNjc6oYl/zrxtyWigtADu3r3MlHsmwfRlL8R9KL7Y1vS
        IRNKlHcU1tSliZ2A7B7CGYDlVV4SAGb6fRKaZ9BAS29c/H27L2O5x8l58zPLyDtennAKBu
        VczYlqGw00LculRgCt9TaIjwVJGFfxI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-537-0zDjdO66MpKbcpi_p5y0PA-1; Thu, 31 Mar 2022 04:28:17 -0400
X-MC-Unique: 0zDjdO66MpKbcpi_p5y0PA-1
Received: by mail-ed1-f69.google.com with SMTP id w8-20020a50d788000000b00418e6810364so14368024edi.13
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 01:28:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yWnBV75IVBvHsDRdv1eIvwYgM5PPl5byFU3eX43vCM0=;
        b=B4XUO5VEQplvekEQnXoPa+AkvNBsvVIvH1ia1We6iLwG0RzhFsVPomH2926BqjR/fT
         sA6V5QDCncWwMNJflnxPcmISSEu6tO7IpWGC2uaUmuQ1QMP2LdFVVF56hSVbNAnWFMKc
         szVXy81XEa6iAX2uDXmQKNSV0JG3WzyFypwlR/AAsMTduV88xye3VuclyNVlxYpo+Weg
         crJuc0zhr29VXaTEZ3Cp6WqjnkzjY3rd/h/Ctpn/Rn4iWXkk3gyGd20OFr7pcWl8nXa4
         jJ9GwuPXBASqTNQULJkl+460CAaFvp163tI6HsvVxPe22tXO0ZkFaNBOpZ6J6y4lf9aV
         UY7w==
X-Gm-Message-State: AOAM533sWvBUqcH70v2BUYmJvLS8wJT+EV+QdvWNgt/TQH8xZgmxNyxC
        bFZzi8oTdKxOxD/2i4WFr9M06Vg7y8kFeqBcwwf3N3U0QS2OLXZpaScGpNRKg+oITJXN2J1wFih
        zdoxEmQqzIaHTTgmv
X-Received: by 2002:a17:907:6e04:b0:6e0:736b:d786 with SMTP id sd4-20020a1709076e0400b006e0736bd786mr3896934ejc.667.1648715295238;
        Thu, 31 Mar 2022 01:28:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwaCi4x7tompAGyNTLCxoxrJWXg1Zwm7R8yDmM3eFPIPwcZfzA65avpZMuaetGN0CCUHQ+R0w==
X-Received: by 2002:a17:907:6e04:b0:6e0:736b:d786 with SMTP id sd4-20020a1709076e0400b006e0736bd786mr3896908ejc.667.1648715294991;
        Thu, 31 Mar 2022 01:28:14 -0700 (PDT)
Received: from [10.39.192.162] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id s24-20020a1709066c9800b006e490a8cf71sm1421208ejr.4.2022.03.31.01.28.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Mar 2022 01:28:14 -0700 (PDT)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     =?utf-8?q?St=C3=A9phane?= Graber <stgraber@ubuntu.com>
Cc:     netdev@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org,
        Frode Nordahl <frode.nordahl@canonical.com>
Subject: Re: [PATCH] openvswitch: Add recirc_id to recirc warning
Date:   Thu, 31 Mar 2022 10:28:13 +0200
X-Mailer: MailMate (1.14r5882)
Message-ID: <1D0EA638-3067-4F74-8E94-3D766D262B39@redhat.com>
In-Reply-To: <20220330194244.3476544-1-stgraber@ubuntu.com>
References: <20220330194244.3476544-1-stgraber@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30 Mar 2022, at 21:42, St=C3=A9phane Graber wrote:

> When hitting the recirculation limit, the kernel would currently log
> something like this:
>
> [   58.586597] openvswitch: ovs-system: deferred action limit reached, =
drop recirc action
>
> Which isn't all that useful to debug as we only have the interface name=

> to go on but can't track it down to a specific flow.
>
> With this change, we now instead get:
>
> [   58.586597] openvswitch: ovs-system: deferred action limit reached, =
drop recirc action (recirc_id=3D0x9e)
>
> Which can now be correlated with the flow entries from OVS.
>
> Suggested-by: Frode Nordahl <frode.nordahl@canonical.com>
> Signed-off-by: St=C3=A9phane Graber <stgraber@ubuntu.com>
> Tested-by: Stephane Graber <stgraber@ubuntu.com>
> ---

This change looks good to me, and it makes debugging easier.

Acked-by: Eelco Chaudron <echaudro@redhat.com>

>  net/openvswitch/actions.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> index 780d9e2246f3..7056cb1b8ba0 100644
> --- a/net/openvswitch/actions.c
> +++ b/net/openvswitch/actions.c
> @@ -1539,8 +1539,8 @@ static int clone_execute(struct datapath *dp, str=
uct sk_buff *skb,
>  				pr_warn("%s: deferred action limit reached, drop sample action\n",=

>  					ovs_dp_name(dp));
>  			} else {  /* Recirc action */
> -				pr_warn("%s: deferred action limit reached, drop recirc action\n",=

> -					ovs_dp_name(dp));
> +				pr_warn("%s: deferred action limit reached, drop recirc action (re=
circ_id=3D%#x)\n",
> +					ovs_dp_name(dp), recirc_id);
>  			}
>  		}
>  	}
> -- =

> 2.34.1

