Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F204FC11B
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 17:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348103AbiDKPnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 11:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348096AbiDKPns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 11:43:48 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112363A731
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 08:41:33 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id f3so14935187pfe.2
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 08:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CKSVJq8qyQSm9E+7b2Am3lv3FrkvK7wUmRfkto+stTY=;
        b=Py6byB+z+qm6GT/cyQ9H3VDiviPg9AOykgcnGDtEPmbJc8P5o7Ee2DRaIziq9LcT70
         rW4lbxFTez6VrSm/K2HtLMyUJ1Oy2GCTkdgPYGb2YKxJLpaBN3F5Uc3SSIYRshGjHgOS
         irSJynYCofXZzSKJsMVD4fgj11ROaQIxOjBJtcDWcK/7gHrxehYg6ILUWbXFcWDErrac
         1kja8yuN9bCfuOuLEitP+D6aT3quzYaj9hDjHrsS3gNyj2ATBTftYsXSSDQ9WPX2MNKh
         YMNJwkjclPARHpRBpUM6r0108ZFRcCC8+aI0QT5qxWXeEE5YYzxEwpuJ+H+gg3gGHHkZ
         0KFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CKSVJq8qyQSm9E+7b2Am3lv3FrkvK7wUmRfkto+stTY=;
        b=4+oREG+8ZxM3qchEWWsIp9d3S1jdXSd75jcfN88Eup0X67m1YcVsTJ1Gr/6omWMGMz
         t1YMDc5lDksz4ri2z8ekyd8FW4HnU7vz/9j9+R1gaAsGd0iBnny3p6hrcFgHnpF42SDF
         kmMcRDQz4MDdHlLuJnjbJLVTEJRCirzMhC42GmGbKO0A+hTWRar2Q4ULA7ebzgvDB06Y
         tlrkW2TtPxwZlMVPdOYr50UVMyR1xgrhSI1RRQ29dpfpQkWaYWvronc1mWdr+o0ZRSbg
         YMdG5q+RIAn+snCbEXxxTohzGHrwiYSPJSl1+fIlL8KRXsztuW7LBfaJ60roDTKKt2ht
         1NAQ==
X-Gm-Message-State: AOAM533EkdqZlvaU7wfd0W1cbu0DOvub6PXb6m2u0PSHIrqa/bbpEQ/b
        3OpWZZaGBIp+phpxATYuSGMtcFyvUT42o3WUkJOJHhBfyLg4dw==
X-Google-Smtp-Source: ABdhPJw3W72mgYRLuP67t01179jiwVBumuQsRGETnRGnwgI+OSwd9njSrKuqgYPdcudiSOGqiFDlqHVWC85wz+P4IKI=
X-Received: by 2002:a63:1557:0:b0:39d:8460:2e07 with SMTP id
 23-20020a631557000000b0039d84602e07mr969931pgv.344.1649691692235; Mon, 11 Apr
 2022 08:41:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220407074428.1623-1-aajith@arista.com> <d7a85a29-0d7f-b5e2-c908-4aa9f89bb476@kernel.org>
In-Reply-To: <d7a85a29-0d7f-b5e2-c908-4aa9f89bb476@kernel.org>
From:   Arun Ajith S <aajith@arista.com>
Date:   Mon, 11 Apr 2022 21:11:18 +0530
Message-ID: <CAOvjArQcH1KRV3B1V9urYEV+6i3ZL6NbmkYjbu1icFBJZ3JVOQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net/ipv6: Introduce accept_unsolicited_na
 knob to implement router-side changes for RFC9131
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net, prestwoj@gmail.com, gilligan@arista.com,
        noureddine@arista.com, gk@arista.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Thank you very much for the review.
I will make the changes you suggested.
Please see inline the question about mausezahn.

On Sat, Apr 9, 2022 at 6:48 AM David Ahern <dsahern@kernel.org> wrote:
>
> On 4/7/22 1:44 AM, Arun Ajith S wrote:
> > Add a new neighbour cache entry in STALE state for routers on receiving
> > an unsolicited (gratuitous) neighbour advertisement with
> > target link-layer-address option specified.
> > This is similar to the arp_accept configuration for IPv4.
> > A new sysctl endpoint is created to turn on this behaviour:
> > /proc/sys/net/ipv6/conf/interface/accept_unsolicited_na.
> >
> > Signed-off-by: Arun Ajith S <aajith@arista.com>
> > Tested-by: Arun Ajith S <aajith@arista.com>
>
> you don't need the Tested-by line since you wrote the patch; you are
> expected to test it.
>
>
> > diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> > index 1afc4c024981..1b4d278d0454 100644
> > --- a/net/ipv6/addrconf.c
> > +++ b/net/ipv6/addrconf.c
> > @@ -5587,6 +5587,7 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
> >       array[DEVCONF_IOAM6_ID] = cnf->ioam6_id;
> >       array[DEVCONF_IOAM6_ID_WIDE] = cnf->ioam6_id_wide;
> >       array[DEVCONF_NDISC_EVICT_NOCARRIER] = cnf->ndisc_evict_nocarrier;
> > +     array[DEVCONF_ACCEPT_UNSOLICITED_NA] = cnf->accept_unsolicited_na;
> >  }
> >
> >  static inline size_t inet6_ifla6_size(void)
> > @@ -7037,6 +7038,13 @@ static const struct ctl_table addrconf_sysctl[] = {
> >               .extra1         = (void *)SYSCTL_ZERO,
> >               .extra2         = (void *)SYSCTL_ONE,
> >       },
> > +     {
> > +             .procname       = "accept_unsolicited_na",
> > +             .data           = &ipv6_devconf.accept_unsolicited_na,
> > +             .maxlen         = sizeof(int),
> > +             .mode           = 0644,
> > +             .proc_handler   = proc_dointvec,
> > +     },
>
> I realize drop_unsolicited_na does not have limits, but this is a new
> sysctl - add the upper and lower bounds via extra1 and extra2 arguments.
>
>
>
> also, please add test cases under tools/testing/selftests/net. You can
> use fib_tests.sh as a template. mausezahn is already used in a number of
> tests; it should be able to create the NA packets. Be sure to cover
> combinations of drop and accept settings.

mausezahn doesn't have good support for ICMPv6.
I tried using --type icmp6 -t icmp6 "type=136, payload=<HEX-PAYLOAD>"
to manually craft a NA packet with  the target address and the target
ll addr option.
But it still doesn't allow me to set the flags to mark it as an
unsolicited advertisement.

How about this alternative for a test:
1. Setup a veth tunnel across two namespaces, one end being the host
and the other the router.
2. On the host side, I can configure
net.ipv6.conf.<interface>.ndisc_notify to send out unsolicited NAs.
3. On the router side, I can try out various combinations of
(accept_unsolicited_na, drop_unsolicted_na and forwarding)

Thanks,
Arun
