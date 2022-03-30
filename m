Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7AE4EC994
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 18:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348748AbiC3QVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 12:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244332AbiC3QVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 12:21:51 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D1370071
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 09:20:05 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-2eafabbc80aso9204997b3.11
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 09:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9p+YHMoXEn+djDAlzGnVfVmbj4X4YfKf8Wmoz4SPcpc=;
        b=Peg1mhc2WUFxEIV29jkkJDS6FeBV6QamEm7Arg1/cxqLNw9sUaPwgYuhCOq9NsRLOR
         vCdXGzvuUEHr6U+tQ6DrV66RGnkXnMKyiumUCdaLZRAZIPL/tEWvcJh+oVb97xPmQnL/
         PoFoz8e0ftaQ0+zaIYqTFiFwFzjRV96x2Df0dzRvz3Dj0TbWZnCGShDoOfg8b7ykX4jU
         /0VVb/90IHWVXPa2F91J3ZnFQ2VAtMsbEQpQEOQPF7khv35jbKM9Jz8NO9V20QwoHjn+
         3h2iR/jeIr8c1mHR0FDpxpT1+WrOWedtoJRzcUE5vpw1nStrZN4lq7zLNuGr54QTDfJb
         2nsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9p+YHMoXEn+djDAlzGnVfVmbj4X4YfKf8Wmoz4SPcpc=;
        b=EX+Q75VPDncEFDXLGUgRclHELXg8cCdnTza6VeL/kLxeymVAEVj4FhAA8eWAJODSCj
         lmnNDZ+L/M7KvUn8NojtTRqGbBhlrTB1kFb7x8UJggg5MuU/qNN0/qOjYenQiLTMi0Cv
         fo3LsUlXcvWZZ4HktAam4JhC5IYlq4srtyEqzC7t2gcvM7+2CIRKcEkCNXzP755k3foy
         Dsyfzoto+qBH4Jz81y18JBb3X4+Yoev2OQeuf1zkdzWKRMWsq5FNHKU/ZpvQGjosyqC2
         MR/rwDxqkDZOQPK0eO+9/rJ33XCEdzu7rZqm1SQFXr03SmIUP5+AZy4YbOzMgi1K76J9
         zuMQ==
X-Gm-Message-State: AOAM530uf0xvCF0AQHpzjH5bypbi/Z0SfjBZgOzR/wiU7KAsqw1/S7rm
        pgwEPRmT2YLvKt8m0OIbHbiF8Zh8VWQYNhAczODM/w==
X-Google-Smtp-Source: ABdhPJw4sJV2PZijTEqCfgQ5qhx6OrerSNXZ76CSL8noTScZod11Zs3XGI5ClTvblmBf3XU5Z6sEJHmccjUzel8jCwQ=
X-Received: by 2002:a81:4f87:0:b0:2e5:dc8f:b4e with SMTP id
 d129-20020a814f87000000b002e5dc8f0b4emr372460ywb.467.1648657204857; Wed, 30
 Mar 2022 09:20:04 -0700 (PDT)
MIME-Version: 1.0
References: <E1nZMdl-0006nG-0J@plastiekpoot> <CADVnQyn=A9EuTwxe-Bd9qgD24PLQ02YQy0_b7YWZj4_rqhWRVA@mail.gmail.com>
 <eaf54cab-f852-1499-95e2-958af8be7085@uls.co.za> <CANn89iKHbmVYoBdo2pCQWTzB4eFBjqAMdFbqL5EKSFqgg3uAJQ@mail.gmail.com>
 <10c1e561-8f01-784f-c4f4-a7c551de0644@uls.co.za> <CADVnQynf8f7SUtZ8iQi-fACYLpAyLqDKQVYKN-mkEgVtFUTVXQ@mail.gmail.com>
 <e0bc0c7f-5e47-ddb7-8e24-ad5fb750e876@uls.co.za>
In-Reply-To: <e0bc0c7f-5e47-ddb7-8e24-ad5fb750e876@uls.co.za>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 30 Mar 2022 09:19:53 -0700
Message-ID: <CANn89i+Dqtrm-7oW+D6EY+nVPhRH07GXzDXt93WgzxZ1y9_tJA@mail.gmail.com>
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP connections
To:     Jaco Kroon <jaco@uls.co.za>
Cc:     Neal Cardwell <ncardwell@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 9:04 AM Jaco Kroon <jaco@uls.co.za> wrote:
>
> Hi,
>
> On 2022/03/30 15:56, Neal Cardwell wrote:
> > On Wed, Mar 30, 2022 at 2:22 AM Jaco Kroon <jaco@uls.co.za> wrote:
> >> Hi Eric,
> >>
> >> On 2022/03/30 05:48, Eric Dumazet wrote:
> >>> On Tue, Mar 29, 2022 at 7:58 PM Jaco Kroon <jaco@uls.co.za> wrote:
> >>>
> >>> I do not think this commit is related to the issue you have.
> >>>
> >>> I guess you could try a revert ?
> >>>
> >>> Then, if you think old linux versions were ok, start a bisection ?
> >> That'll be interesting, will see if I can reproduce on a non-production
> >> host.
> >>> Thank you.
> >>>
> >>> (I do not see why a successful TFO would lead to a freeze after ~70 KB
> >>> of data has been sent)
> >> I do actually agree with this in that it makes no sense, but disabling
> >> TFO definitely resolved the issue for us.
> >>
> >> Kind Regards,
> >> Jaco
> > Thanks for the pcap trace! That's a pretty strange trace. I agree with
> > Eric's theory that this looks like one or more bugs in a firewall,
> > middlebox, or netfilter rule. From the trace it looks like the buggy
> > component is sometimes dropping packets and sometimes corrupting them
> > so that the client's TCP stack ignores them.
> The capture was taken on the client.  So the only firewall there is
> iptables, and I redirected all -j DROP statements to a L_DROP chain
> which did a -j LOG prior to -j DROP - didn't pick up any drops here.
> >
> > Interestingly, in that trace the client SYN has a TFO option and
> > cookie, but no data in the SYN.
>
> So this allows the SMTP server which in the conversation speaks first to
> identify itself to respond with data in the SYN (not sure that was
> actually happening but if I recall I did see it send data prior to
> receiving the final ACK on the handshake.
>
> >
> > The last packet that looks sane/normal is the ACK from the SMTP server
> > that looks like:
> >
> > 00:00:00.000010 IP6 2a00:1450:4013:c16::1a.25 >
> > 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.48590: . 6260:6260(0) ack 66263 win
> > 774 <nop,nop,TS val 1206544341 ecr 331189186>
> >
> > That's the first ACK that crosses past 2^16. Maybe that is a
> > coincidence, or maybe not. Perhaps the buggy firewall/middlebox/etc is
>
> I believe it should be because we literally had this on every single
> connection going out to Google's SMTP ... probably 1/100 connections
> managed to deliver an email over the connection.  Then again ... 64KB
> isn't that much ...
>
> When you state sane/normal, do you mean there is fault with the other
> frames that could not be explained by packet loss in one or both of the
> directions?
>
> > confused by the TFO option, corrupts its state, and thereafter behaves
> > incorrectly past the first 64 KBytes of data from the client.
>
> Only firewalls we've got are netfilter based, and these packets all
> passed through the dedicated firewalls at least by the time they reach
> here.  No middleboxes on our end, and if this was Google's side there
> would be crazy noise be heard, not just me.  I think the trigger is
> packet loss between us (as indicated we know they have link congestion
> issues in JHB area, it took us the better part of two weeks to get the
> first line tech on their side to just query the internal teams and
> probably another week to get the response acknowledging this -
> mybroadband.co.za has an article about other local ISPs also complaining).
>
> >
> > In addition to checking for checksum failures, mentioned by Eric, you
> > could look for PAWS failures, something like:
> >
> >   nstat -az | egrep  -i 'TcpInCsumError|PAWS'
>
> TcpInCsumErrors                 0                  0.0
> TcpExtPAWSActive                0                  0.0
> TcpExtPAWSEstab                 90092              0.0
> TcpExtTCPACKSkippedPAWS         81317              0.0
>
> Not sure what these mean, but i should probably investigate, the latter
> two are definitely incrementing.
>
> Appreciate the feedback and for looking at the traces.
>

Your pcap does not show any obvious PAWS issues.

If the host is lightly loaded you could try while the connection is
attempted/frozen

perf record -a -g -e skb:kfree_skb sleep 30
perf script  (or perf report)
