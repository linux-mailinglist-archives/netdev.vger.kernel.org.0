Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA984F97FD
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 16:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236088AbiDHO2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 10:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbiDHO2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 10:28:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD7A0353A86
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 07:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649427985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U/YHMItOU+qanl1IKgeEpnW9Tb0W/QBY4RY/ynGzeOU=;
        b=C9ZM5gtOhgkDh83l65wXxX97HGjBRS0uxDwN69Y2tY30TJJi67PkWRtfIbD76xMIQQFHee
        C4kLfXqB1TkpVquLCUnzQq1h8WUof8CUBrG+h0ZpdC785a2qQC3eiLoBl2hS/4+J4OH3Uj
        GmCyRykQpLJcETow4CsTSqpkDMc0PHA=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-Qsh1bwCgPIqItCaM8vly5w-1; Fri, 08 Apr 2022 10:26:24 -0400
X-MC-Unique: Qsh1bwCgPIqItCaM8vly5w-1
Received: by mail-yb1-f197.google.com with SMTP id x9-20020a5b0809000000b00631d9edfb96so6749477ybp.22
        for <netdev@vger.kernel.org>; Fri, 08 Apr 2022 07:26:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U/YHMItOU+qanl1IKgeEpnW9Tb0W/QBY4RY/ynGzeOU=;
        b=Wkxmit9HSG5WQlGqnqq7cj0hNkOKb+BKz2VwZgq5cR/otoe62YOG+2knFRtA3gEAy5
         vJcxeW6TlWZde6eLl3lgO42CZQd389bcfd2SGYw2q91HcwHtiFkJtFE7fyTzNkgBMmIn
         gy3PJdGwbpb3M1YmVN7iGvPlqWv8uyj+fUskiaRRQOpSxa2hcFcuIS+0UHWOFFo8CiZx
         1q4wDmoKRV5nlUYJHQRDpPgef98z5/gM7gKc8m+VaglsJSgjMKMo4Osv7H7iNps20P6R
         W+8NI5GLw3FHCpbLnmgCZMYTk3iw8mRlDTsvcdY9bL2NrCpQ6UlY1/OCI/L9AnD1X1Gy
         hLaA==
X-Gm-Message-State: AOAM532/HbGOwDYEvsPBsBNiWjRRjnB7DT7+SLBppmaX6NSb2SDa1JV4
        lZgw9guNL55yhZU/trAYfNb5M5RPF7H88lg9rvaS4RnS5eJjH+cBV/99rxNjUtRr93ULDFKCkKa
        VOIKalF+l+B3akq7ObC0mCgMS5mxxXbBG
X-Received: by 2002:a81:5707:0:b0:2eb:373b:cfad with SMTP id l7-20020a815707000000b002eb373bcfadmr1860378ywb.245.1649427984316;
        Fri, 08 Apr 2022 07:26:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDY7g4msku33cedhyATV50/zFOel9CLRy4+oIf9hSqv4+eV4sspV/jrxYgQab8+Gq5PXbThJHBA/tYa0GCgrk=
X-Received: by 2002:a81:5707:0:b0:2eb:373b:cfad with SMTP id
 l7-20020a815707000000b002eb373bcfadmr1860362ywb.245.1649427984130; Fri, 08
 Apr 2022 07:26:24 -0700 (PDT)
MIME-Version: 1.0
References: <71becb489e51284edf0c11fc15246f4ed4cef5b6.1649337862.git.lucien.xin@gmail.com>
In-Reply-To: <71becb489e51284edf0c11fc15246f4ed4cef5b6.1649337862.git.lucien.xin@gmail.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Fri, 8 Apr 2022 16:26:12 +0200
Message-ID: <CAFqZXNukNQFROHqhrjnW0EyQjBiYC4LfNcAmu_Fq_mfCi-kd_g@mail.gmail.com>
Subject: Re: [PATCHv2 net] sctp: use the correct skb for security_sctp_assoc_request
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 7, 2022 at 3:24 PM Xin Long <lucien.xin@gmail.com> wrote:
> Yi Chen reported an unexpected sctp connection abort, and it occurred when
> COOKIE_ECHO is bundled with DATA Fragment by SCTP HW GSO. As the IP header
> is included in chunk->head_skb instead of chunk->skb, it failed to check
> IP header version in security_sctp_assoc_request().
>
> According to Ondrej, SELinux only looks at IP header (address and IPsec
> options) and XFRM state data, and these are all included in head_skb for
> SCTP HW GSO packets. So fix it by using head_skb when calling
> security_sctp_assoc_request() in processing COOKIE_ECHO.
>
> v1->v2:
>   - As Ondrej noticed, chunk->head_skb should also be used for
>     security_sctp_assoc_established() in sctp_sf_do_5_1E_ca().
>
> Fixes: e215dab1c490 ("security: call security_sctp_assoc_request in sctp_sf_do_5_1D_ce")
> Reported-by: Yi Chen <yiche@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/sm_statefuns.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index 7f342bc12735..52edee1322fc 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -781,7 +781,7 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
>                 }
>         }
>
> -       if (security_sctp_assoc_request(new_asoc, chunk->skb)) {
> +       if (security_sctp_assoc_request(new_asoc, chunk->head_skb ?: chunk->skb)) {
>                 sctp_association_free(new_asoc);
>                 return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
>         }
> @@ -932,7 +932,7 @@ enum sctp_disposition sctp_sf_do_5_1E_ca(struct net *net,
>
>         /* Set peer label for connection. */
>         if (security_sctp_assoc_established((struct sctp_association *)asoc,
> -                                           chunk->skb))
> +                                           chunk->head_skb ?: chunk->skb))
>                 return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
>
>         /* Verify that the chunk length for the COOKIE-ACK is OK.
> @@ -2262,7 +2262,7 @@ enum sctp_disposition sctp_sf_do_5_2_4_dupcook(
>         }
>
>         /* Update socket peer label if first association. */
> -       if (security_sctp_assoc_request(new_asoc, chunk->skb)) {
> +       if (security_sctp_assoc_request(new_asoc, chunk->head_skb ?: chunk->skb)) {
>                 sctp_association_free(new_asoc);
>                 return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
>         }
> --
> 2.31.1

FWIW:

Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>

Thanks!

-- 
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

