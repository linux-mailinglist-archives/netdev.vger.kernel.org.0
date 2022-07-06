Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42EC156822C
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 10:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbiGFI4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 04:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiGFI4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 04:56:05 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1562F2497D;
        Wed,  6 Jul 2022 01:56:04 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id e40so18387575eda.2;
        Wed, 06 Jul 2022 01:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TiSbYoSDE0lMlfqj+l2CCSMOXHr+cfG4LYMnjViLfKg=;
        b=iZgloJtbC+6whSU9AepPlzjoWEwtuEoHIfHnGtNlQ4C7UtGfnEEmVwBmNUQ+hp8QPE
         srctWeLgf/fotpb89l8rI9lg4mQnr87w7+3vinjVE3RJNZRD0kzVD+wvsw7UaK+t8/s1
         st8AI91D07QbVN2WkuVWV8CPl3yJX9BZwJFdkx0W5TdbJV2D1CKOCqCSvlq6wN6RqaPf
         UUjR7td8tkJqcXdBiPbDT5qzW5f7hWK/dJbmdUy1js1wwVwqnvzOz88LxLXf05GrHzur
         AKLeY/3k9Tub41UOdBMxbshm3a3Agu7xGvCJZt+FuehosHVD+1D5nfFrAlxRw5PKNxdD
         XPoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TiSbYoSDE0lMlfqj+l2CCSMOXHr+cfG4LYMnjViLfKg=;
        b=7zOHLWKAPXgGCodGXBfeno64XrpFtSqM2ngQxGuB/S9tfbuqZcSiLMM1LSlZfWtonN
         JoVXvXJKR/jpswYL2sgkC6TcT+iLhQaPagGVSXojKRFCCq/d8JGdbF3sAzZFjoOw1aAX
         bXzt/kuLUIAf/q1/NzdMPSow4cBjCyyvHndK572UbA2fTJFJ6r039zkOtN8JaoLj9Fc/
         RX9LiyEpWgqdCQTgw3nxtvzJx2h+5nnJqwWjF/IWntcw8Xt/B4UtuGI5v6bm5xqmBtjM
         rmCirfQgw61LN3413VnP4z9omVywWYVWd/1dtrTOWKG34WwyHvnFYTGr1TuEQ6AukDdd
         9lMQ==
X-Gm-Message-State: AJIora9kbQ609EjCdC8LD2XfDFhQJmKzfHK5CB6g5DoeiupSWQd72gkW
        qgX7Nlyamr98WiWQHv9MbrM=
X-Google-Smtp-Source: AGRyM1sX+A6RqHnQ5QmWzoiAncEiL9RQsnExvWaj8wwcC2AJnUx5vD9KmRmIFnuBHDzZTV1CprW1Hw==
X-Received: by 2002:aa7:ce8a:0:b0:43a:7b0e:9950 with SMTP id y10-20020aa7ce8a000000b0043a7b0e9950mr9208313edv.58.1657097762610;
        Wed, 06 Jul 2022 01:56:02 -0700 (PDT)
Received: from skbuf ([188.26.185.61])
        by smtp.gmail.com with ESMTPSA id i10-20020a170906698a00b00705fa7087bbsm17260818ejr.142.2022.07.06.01.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 01:56:01 -0700 (PDT)
Date:   Wed, 6 Jul 2022 11:55:59 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans S <schultz.hans@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH V3 net-next 3/4] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20220706085559.oyvzijcikivemfkg@skbuf>
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
 <20220524152144.40527-4-schultz.hans+netdev@gmail.com>
 <20220627180557.xnxud7d6ol22lexb@skbuf>
 <CAKUejP7ugMB9d3MVX3m9Brw12_ocFoT+nuJJucYdQH70kzC7=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKUejP7ugMB9d3MVX3m9Brw12_ocFoT+nuJJucYdQH70kzC7=w@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 02:26:43PM +0200, Hans S wrote:
> > Dumb question: if you only flush the locked entries at fast age if the
> > port is locked, then what happens with the existing locked entries if
> > the port becomes unlocked before an FDB flush takes place?
> > Shouldn't mv88e6xxx_port_set_lock() call mv88e6xxx_atu_locked_entry_flush()
> > too?
> 
> That was my first thought too, but the way the flags are handled with the mask etc, does so that
> mv88e6xxx_port_set_lock() is called when other flags change. It could be done by the transition
> from locked->unlocked by checking if the port is locked already.

Why does mv88e6xxx_port_set_lock() get called when other flags change?

> On the other hand, the timers will timeout and the entries will be removed anyhow.

> > > +static void mv88e6xxx_atu_locked_entry_timer_work(struct atu_locked_entry *ale)
> >
> > Please find a more adequate name for this function.
> 
> Any suggestions?

Not sure. It depends on whether you leave just the logic to delete a
locked ATU entry, or also the switchdev FDB_DEL_TO_BRIDGE notifier.
In any case, pick a name that reflects what it does. Something with
locked_entry_delete() can't be too wrong.

> > From the discussion with Ido and Nikolay I get the impression that
> > you're not doing the right thing here either, notifying a
> > SWITCHDEV_FDB_DEL_TO_BRIDGE from what is effectively the
> > SWITCHDEV_FDB_DEL_TO_DEVICE handler (port_fdb_del).
> 
> Hmm, my experience tells me that much is opposite the normal
> conventions when dealing with
> locked ports, as there was never switchdev notifications from the
> driver to the bridge before, but
> that is needed to keep ATU and FDB entries in sync.

On delete you mean? So the bridge signals switchdev a deletion of a
locked FDB entry (as I pointed out, this function gets indirectly called
from port_fdb_del), but it won't get deleted until switchdev signals it
back, is what you're saying?

> > Why is the rtnl_unlock() outside the switch statement but the rtnl_lock() inside?
> > Not to mention, the dsa_port_to_bridge_port() call needs to be under rtnl_lock().
> 
> Just a small optimization as I also have another case of the switch
> (only one switch case if
> you didn't notice) belonging to the next patch set regarding dynamic
> ATU entries.

What kind of optimization are you even talking about? Please get rid of
coding patterns like this, sorry.

> > Please, no "if (chiplock) mutex_lock()" hacks. Just lockdep_assert_held(&chip->reg_lock),
> > which serves both for documentation and for validation purposes, ensure
> > the lock is always taken at the caller (which in this case is super easy)
> > and move on.
> 
> As I am calling the function in if statement checks, it would make
> that code more messy, while with
> this approach the function can be called from anywhere. I also looked
> at having two functions, with
> one being a wrapper function taking the lock and calling the other...

There are many functions in mv88e6xxx that require the reg_lock to be
held, there's nothing new or special here.

> >
> > > +
> > > +     if (mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL0, &reg))
> > > +             goto out;
> >
> > It would be good to actually propagate the error to the caller and
> > "locked" via a pass-by-reference bool pointer argument, not just say
> > that I/O errors mean that the port is unlocked.
> 
> Again the wish to be able to call it from if statement checks,.
> 
> > > +     reg &= MV88E6XXX_PORT_ASSOC_VECTOR_PAV_MASK;
> > > +     if (locked) {
> > > +             reg |= MV88E6XXX_PORT_ASSOC_VECTOR_IGNORE_WRONG |
> > > +                     MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT |
> > > +                     MV88E6XXX_PORT_ASSOC_VECTOR_INT_AGE_OUT |
> > > +                     MV88E6XXX_PORT_ASSOC_VECTOR_HOLD_AT_1;
> >
> > I'd suggest aligning these macros vertically.
> 
> They are according to the Linux kernel coding standard wrt indentation afaik.

Compare:

		reg |= MV88E6XXX_PORT_ASSOC_VECTOR_IGNORE_WRONG |
			MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT |
			MV88E6XXX_PORT_ASSOC_VECTOR_INT_AGE_OUT |
			MV88E6XXX_PORT_ASSOC_VECTOR_HOLD_AT_1;

with:

		reg |= MV88E6XXX_PORT_ASSOC_VECTOR_IGNORE_WRONG |
		       MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT |
		       MV88E6XXX_PORT_ASSOC_VECTOR_INT_AGE_OUT |
		       MV88E6XXX_PORT_ASSOC_VECTOR_HOLD_AT_1;
