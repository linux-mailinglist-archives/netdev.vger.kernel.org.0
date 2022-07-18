Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7635782A7
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235130AbiGRMpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235148AbiGRMpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:45:21 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9237725CF;
        Mon, 18 Jul 2022 05:45:18 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id g1so15058978edb.12;
        Mon, 18 Jul 2022 05:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7IFWD9rOa3cFODsg1oktUNlaFZA0e+wgChqqA5r3lCI=;
        b=p99zhkWDhGKA9ODAY4+fX755zVNNl2uBbiyFPYAnIQvQWiJFTqyNGkW3C0DzPEjOb3
         j+G+6wuy0P+F4C2i4P6hFKSpgmEjYEmSK0IT5RNbEZS8J+fZzMDYiQ9AbtRqLzE/Tq+2
         skI9/wvTs12rRJBKiDGFglkfWh9WnsRkOyNiZiBRzMKFVXZjkDLaSAbkPPCVzywcKyjE
         anC5IAiERpDb9JKmR0/5rInOIr99OLVjginZebH1Mhawk5jL2JdGborFpdVP6OeWd4jH
         IfSAaisx4w6GrAC8rDc4hfUQZ+L9G8s5t6bWa6u8Qxs9I0iFXaHzybaP/hgM+mf7Cqnz
         EV3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7IFWD9rOa3cFODsg1oktUNlaFZA0e+wgChqqA5r3lCI=;
        b=nIDZ11k1ZIMYjeeZlwCuh5T3JsJFkbIU6+HjrIgK5kE2zrBvRDfEWzqqxeDnIOEvrS
         O1C1K2X2CQYgweeDhWwLuzmBk7R0p8sVvTJXFwTcu3UeYpUtSAGu4jnpjTuyRgaAbpUC
         G+CGbv4FT47wFssn3wMmhnad5hJB2Ln8VoN0w19THkFNFwi955v1U6egWl6zBV3XupIB
         YV3tEmEKQpIwnlfZ3W0PKEfVA6l2pPg0U9EXqsJM+hNsnYcTK/RNNfDZUHSEIyORFkpw
         aj4yZm/x1OKOcB5RI0g9Nf16L5aCYUYnpkN7iPHgHWgqw1jWD94FQP9eKfMQaCvTi7+M
         1nZw==
X-Gm-Message-State: AJIora+oqYhO8Btt7v8cOi9tDjX9TsCYdSJgsW0Z5JlnSONak3q6tDOl
        P1DCJzE83PouMvTmQJG0tlQ=
X-Google-Smtp-Source: AGRyM1tftSsQe96gfC6pO/qh3Lmxwz+DSL7dJlk0+NqGLz73Ov2REjs7OOwC8Gn51DlQnG3TpSv6kw==
X-Received: by 2002:a05:6402:4245:b0:43a:961a:583f with SMTP id g5-20020a056402424500b0043a961a583fmr37014957edb.374.1658148316878;
        Mon, 18 Jul 2022 05:45:16 -0700 (PDT)
Received: from skbuf ([188.25.231.190])
        by smtp.gmail.com with ESMTPSA id w5-20020aa7dcc5000000b00438a13508c4sm8553032edu.51.2022.07.18.05.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 05:45:15 -0700 (PDT)
Date:   Mon, 18 Jul 2022 15:45:12 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net-next 0/6] net: dsa: always use phylink
Message-ID: <20220718124512.o3qxiwop7nzfjbfx@skbuf>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <20220715171719.niqcrklpk4ittfvl@skbuf>
 <YtHVLGR0RQ6dWuBS@shell.armlinux.org.uk>
 <20220715160359.2e9dabfe@kernel.org>
 <20220716111551.64rjruz4q4g5uzee@skbuf>
 <YtKkRLD74tqoeBuR@shell.armlinux.org.uk>
 <20220716131345.b2jas3rucsifli7g@skbuf>
 <YtUfg+WYIYYi5J+q@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtUfg+WYIYYi5J+q@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 09:53:23AM +0100, Russell King (Oracle) wrote:
> On Sat, Jul 16, 2022 at 04:13:45PM +0300, Vladimir Oltean wrote:
> > On Sat, Jul 16, 2022 at 12:43:00PM +0100, Russell King (Oracle) wrote:
> > > In the first RFC series I sent on the 24 June, I explicitly asked the
> > > following questions:
> > (...)
> > > I even stated: "Please look at the patches and make suggestions on how
> > > we can proceed to clean up this quirk of DSA." and made no mention of
> > > wanting something explicitly from Andrew.
> > > 
> > > Yet, none of those questions were answered.
> > > 
> > > So no, Jakub's comments are *not* misdirected at all. Go back and read
> > > my June 24th RFC series yourself:
> > > 
> > > https://lore.kernel.org/all/YrWi5oBFn7vR15BH@shell.armlinux.org.uk/
> > 
> > I don't believe I need to justify myself any further for why I didn't
> > leave a comment on any certain day. I left my comments when I believed
> > it was most appropriate for me to intervene (as someone who isn't really
> > affected in any way by the changes, except for generally maintaining
> > what's in net/dsa/, and wanting to keep a clean framework structure).
> > Also, to repeat myself, blaming me for leaving comments, but doing so
> > late, is not really fair. I could have not responded at all, and I
> > wouldn't be having this unpleasant discussion. It begs the question
> > whether you're willing to be held accountable in the same way for the
> > dates on which you respond on RFC patches.
> > 
> > > I've *tried* my best to be kind and collaborative, but I've been
> > > ignored. Now I'm hacked off. This could have been avoided by responding
> > > to my explicit questions sooner, rather than at the -rc6/-rc7 stage of
> > > the show.
> > 
> > I think you should continue to try your best to be kind and collaborative,
> > you weren't provoked or intentionally ignored in any way, and it isn't
> > doing these patches any good.
> 
> And yet again, I don't have answers to many of those questions... which
> just shows how broken this process is, and how utterly pointless it is
> 0to ask any questions in this area.
> 
> My conclusion: you don't care one bit to even answer questions until
> there's a chance that patches that you disagree with might be merged,
> and oh my god, you've got to respond to stop that happening because you
> might disagree with something. You can't do the collaborative thing and
> respond when someone asks explicit questions about how things should be
> done.
> 
> I'm not going to let this go. I'm really pissed off by this and you
> are the focus of my frustration.

The hypothesis that you put forward is that I'm sabotaging you by not
responding to RFCs, then leaving comments when you submit the patches
proper, just so that they're delayed because I don't agree with them;
and that the process is broken because it allows me to do just that and
get away with it (for fun, I assume?).

So first off, you sent the first RFC towards 2 people in To:, and 19
people in Cc:. I was one of the people in Cc. You didn't ask *me* any
explicit question. In fact, when you did, I responded within 5 hours:
https://lore.kernel.org/linux-arm-kernel/20220707154303.236xaeape7isracw@skbuf/

Then, why did I not respond earlier to questions I had an opinion on?

Based on prior experience, anything I reply to you has a chance of
inflaming you for reasons that are outside of my control, and the
discussion derails and eventually ends with you saying that I'm being
difficult and you're quitting for the day, week, month, kernel release
cycle or what not. I'm not saying that's my fault or your fault in
general, it's just a statistical observation based on past interactions,
and it looks like this one is no different.

With regard to this topic, there was ample opportunity for the patch set
to come to a resolve without my intervention, and I decided that the
best way to maximize the chances of this discussion not going sideways
is to not say anything at all, especially when I don't need to.
Gradually, the opportunity for the patch set to resolve itself without
my intervention diminished, and I started offering my feedback to the code.

It's perhaps necessary of me to not let this phrase of yours unaddressed,
because it is subtly part of your argument that I'm just trying to delay
your patches as part of a sabotage plot:

| The only thing that delayed them was your eventual comments about
| re-working how it was being done.

Let's not forget that I did *not* request you to rework the implementation
to use software nodes. I simply went with the code you originally proposed,
explained why it is unnaturally structured in my view, asked you why you
did not consider an alternative structure if you're not willing to make
phylink absorb the logic, then you said you'd be happy to rework using
software nodes.
https://lore.kernel.org/netdev/20220707193753.2j67ni3or3bfkt6k@skbuf/

My feedback was very actionable, I put forward a working prototype for
using software nodes that did consume time for me to write, I was not
being handwavy in any way. More importantly, you agreed with it and are
using it now. And all of that happened during RFC stages. To ignore
these facts when you state that I respond only to non-RFC patches is a
lie by omission. I give feedback to code in the order of importance.
Now was the time to point out that (a) I don't want to add support for
the defaulting mode on CPU ports for drivers that didn't have it
previously, and (b) I'd like to keep the current implementation of the
defaulting feature as "don't register with phylink" as the default, with
just an opt-in to create the software node. Drivers can opt into that
behavior as need shows (breakage reports). Again, this is all extremely
actionable feedback, and rather minor in the grand scheme of things.


So I'm sorry, but your frustration expressed towards me for ignoring RFC
patches *is* misdirected and there's nothing I will consider changing.
If the discussion derailed now due to me it doesn't mean it wouldn't
have derailed earlier. There are still many people who could have said
more things than they did, and yet, I'm not even blaming them for not
doing that. There is a chapter in a book by Robert Cialdini called
"Influence: The Psychology of Persuasion" which discusses social proof,
the mechanism through which people tend to do what others do when
otherwise unsure. I'm paraphrasing, but there is a paragraph discussing
what can be done when social proof works against you, for example you're
being attacked on the street, you ask for help and nobody appears to do
anything except for passing by. Summarized, you should ask for very
specific things, point to people, say names, rather than get frustrated
that the crowd does nothing.

> Well, its now too late to do anything about this. This is going to miss
> this cycle. It might get in next cycle, and whoopy do, for a kernel
> that's very likely to be a LTS. Given the lack of testing that sounds
> like a complete and utter disaster. One that was entirely avoidable had
> feedback been given EARLIER in this cycle.

If your patch set was a silver bullet to avoid breakage, that would have
maybe changed things a little, but it isn't. For any driver that might
boot using a DT blob with the defaulting feature for the CPU port, there
is a gamble to be taken whether the better thing to do is to unleash phylink
at it unattended or to let it be. Obviously having a driver maintainer
assist phylink would be the correct thing, but until the board in question
reaches a maintainer, chances are it will probably reach a user.

What I'm trying to obtain in terms of changes is that the user can at
least correlate the breakage he's seeing with a dmesg warning message
that clearly indicates what phylink or DSA tried to do in lack of clear
DT description.
