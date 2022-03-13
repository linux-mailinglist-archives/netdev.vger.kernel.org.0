Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3225C4D7848
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 21:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbiCMU7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 16:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbiCMU7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 16:59:23 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CA1396B7;
        Sun, 13 Mar 2022 13:58:14 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id w27so23910042lfa.5;
        Sun, 13 Mar 2022 13:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NLLbMMtHgsKVb72tIMIjR4Fcr1wc3d4VHtttjyelNHs=;
        b=bJCUutt57NQfgZ9HVDm9GhgI/n+pXmOMB4K0my5wppnDXJ3JmO9SSj3QQcvRzixkDQ
         mVaY7O6xvbSstw5TCxlfK7Wj4SOYWpzacfECG86TLudvPpotlo7k6eIR+faLPoCzqHK5
         kVAIjCUCDcuGI2BUa/YDZHeedw9Fjqd8yEE/78zK4eiRLJc/MpNAOoelxLiBlN0EW1Jc
         i7dJ7OXHNTb4G0e1gpRPgyP1QD2lyinKTosWbZr3+WVWsQM43sZcFBBpEDfk1Bo5ioEG
         tdG1xtcH13WeBaZBdR+lGLsgu4gJQIsIm6r/+dzNtgh9hBsw5e0rSZSJDJ799fB1aVQG
         9gZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NLLbMMtHgsKVb72tIMIjR4Fcr1wc3d4VHtttjyelNHs=;
        b=XpYW3HLP0NztIlOTVc+V+k7k9qxguiMUufAKab5JAMCY/b8uKZ89LAyLQkA4fPKYAV
         UKk5fo9RaK21YCkCtyuwMhtn1WCY6QnqjFpHgTz6CTcjjZ4X+JdCcEu0g5N7c3wyoI7Z
         sPDd4apEMGoxEybBbIwvCZNs73hSuNTWEmppbBicVeHJDlPnizyIhBct11/fCNDrlqU8
         UB375oi5Urb599Vdu+5pHMJBFSEo2PeFoU4UpLRxLha5mYL/7SpbN0Wg6iOOuWjnbyR7
         EO4rXmkPziSzWd84dubRfwAku9CE/3aMJoOIDmIfaM6ZGQp4IkH2ftOlmQMvwjiidIL6
         KyEw==
X-Gm-Message-State: AOAM530OehP+MChPo/4OTms/KyxsSqewAgeZj8M5vtUqUDNslfoatNXK
        Cvas+pmm7TjVl3pHiKqWvpwKJ+CmQvCGQ7PlBZQ=
X-Google-Smtp-Source: ABdhPJyJX50Vxu1GTNRNrMmXqBZQVrs0GAvKT58+cniDNFgbdaFcRBOoZ8pxDOSZxKsmd0H171BefGCUDCG7vfVmXAA=
X-Received: by 2002:a05:6512:260e:b0:448:97b8:94b0 with SMTP id
 bt14-20020a056512260e00b0044897b894b0mr912038lfb.226.1647205092810; Sun, 13
 Mar 2022 13:58:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220128110825.1120678-1-miquel.raynal@bootlin.com>
 <20220128110825.1120678-2-miquel.raynal@bootlin.com> <CAB_54W60OiGmjLQ2dAvnraq6fkZ6GGTLMVzjVbVAobcvNsaWtQ@mail.gmail.com>
 <20220131152345.3fefa3aa@xps13> <CAB_54W7SZmgU=2_HEm=_agE0RWfsXxEs_4MHmnAPPFb+iVvxsQ@mail.gmail.com>
 <20220201155507.549cd2e3@xps13> <CAB_54W5mnovPX0cyq5dwVoQKa6VZx3QPCfVoPAF+LQ5DkdQ3Mw@mail.gmail.com>
 <20220207084918.0c2e6d13@xps13> <CAB_54W6RC9dqRzPyN3OYb6pWfst+UixSAKppaCtDaCvzE0_kAQ@mail.gmail.com>
 <20220302142138.4122b3c6@xps13>
In-Reply-To: <20220302142138.4122b3c6@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 13 Mar 2022 16:58:01 -0400
Message-ID: <CAB_54W5e2pgHtUXA41gn9B86e8Q-y3pWOty=cCv0FJd2V1b7yA@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 1/5] net: ieee802154: Improve the way
 supported channels are declared
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Mar 2, 2022 at 8:21 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Sun, 20 Feb 2022 18:05:39 -0500:
>
> > Hi,
> >
> > On Mon, Feb 7, 2022 at 2:49 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > Hi Alexander,
> > >
> > > alex.aring@gmail.com wrote on Sun, 6 Feb 2022 16:37:23 -0500:
> > >
> > > > Hi,
> > > >
> > > > On Tue, Feb 1, 2022 at 9:55 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > ...
> > > > >
> > > > > Given the new information that I am currently processing, I believe the
> > > > > array is not needed anymore, we can live with a minimal number of
> > > > > additional helpers, like the one getting the PRF value for the UWB
> > > > > PHYs. It's the only one I have in mind so far.
> > > >
> > > > I am not really sure if I understood now. So far those channel/page
> > > > combinations are the same because we have no special "type" value in
> > > > wpan_phy,
> > >
> > > Yes, my assumption was more: I know there are only -legacy- phy types
> > > supported, we will add another (or improve the current) way of defining
> > > channels when we'll need to. Eg when improving UWB support.
> > >
> > > > what we currently support is the "normal" (I think they name
> > > > it legacy devices) phy type (no UWB, sun phy, whatever) and as Channel
> > > > Assignments says that it does not apply for those PHY's I think it
> > > > there are channel/page combinations which are different according to
> > > > the PHY "type". However we don't support them and I think there might
> > > > be an upcoming type field in wpan_phy which might be set only once at
> > > > registration time.
> > >
> > > An idea might be to create a callback that drivers might decide to
> > > implement or not. If they implement it, the core might call it to get
> > > further information about the channels. The core would provide a {page,
> > > channel} couple and retrieve a structure with many information such as
> > > the the frequency, the protocol, eventually the prf, etc.
> > >
> >
> > As I said before, for "many information" we should look at how
> > wireless is using that with regdb and extend it with 802.15.4
> > channels/etc. The kernel should only deal with an unique
> > identification of a database key for "regdb" which so far I see is a
> > combination of phy type, page id and channel id. Then from "somewhere"
> > also the country code gets involved into that and you get a subset of
> > what is available.
>
> Do you want another implementation of regdb that would support the
> 802.15.4 world only (so far it is highly 802.11 oriented) ? Or is this
> something that you would like to merge in the existing project?
>

I think we should run the strategy like wpan-tools, fork it but leave
it open that probably they can be merged in future. How about that?

I don't like that it is wireless standard specific, it should be
specific to the standard which defines the regulation... As an
example, I remember that at86rf212 has some LBT (listen before
transmit) mode because of some duty cycle regulations in some
countries. The regdb should not contain if LBT should be used in a
country for specific sub 1Ghz range, etc. It should contain the duty
cycle allowance. That's an example of what I mean with "wireless
standard" and "regulation standard". However the regulation for sub
1Ghz is also a little bit crazy so far I see. :)

However I really don't know if this is extremely difficult to handle.
I would say this would be the better approach but if it doesn't work
do it wireless specific. So it's up to whoever wants to do the work?

> Overall it can be useful to define what is allowed in different
> countries but this will not save us from needing extra information from
> the devices. Describing the channels and protocols (and PRFs) for an
> UWB PHY has nothing to do with the regulatory database, it's just
> listing what is supported by the device. The actual location where it
> might be useful to have a regdb (but not mandatory at the beginning)
> would be when changing channels to avoid messing with local
> regulations, I believe?
>

I see, but I am not sure what additional information you need as
channel, page, phy type? And if you have those values in user space
you can get other information out of it, or not? Why does the kernel
need to handle more than necessary? Even there we can use helpers to
map those combinations to something else. Just avoid that drivers
declare those information what they already declared and introduce
helpers to whatever higher level information you want to get out of
it.

- Alex
