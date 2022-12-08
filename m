Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9377B6470DC
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 14:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiLHNfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 08:35:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiLHNfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 08:35:34 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640C389313;
        Thu,  8 Dec 2022 05:35:29 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id kw15so3893248ejc.10;
        Thu, 08 Dec 2022 05:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qYdYNaBhlf54ReXjnoyJdD2m/UHiYs71sMyYCk/LAFM=;
        b=T4YTEFRQVi6FyDUBf0seS9oH9gDVh4GPndcxKFucOK7SUBe/j0PmQ3ITX/l3UTHqOE
         Os280YXXxwxNap3DbBg6Y0473VCiaSASf/Lev0oRwtMe+QRWJkWoURYk/2B9M3SGYOvB
         NKubDhOg5JtLw2VxkF2jSBO1MH1Iyk4b2U885MQncaRG5wZCh8BplLjY8zTnkfmpftAl
         KWzriQRq/wKz82c+IYzNDitMX0ymL/QoRt67cIHpyoDrWWwwEWBSsOi2lsnuK2jXgxay
         qH7OMlxds1gnGvinWJgQSa9SsuONqwDCOtU8sluCHQoU5FupdGQWf/b2/FFxm2SZvcpu
         Vt2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qYdYNaBhlf54ReXjnoyJdD2m/UHiYs71sMyYCk/LAFM=;
        b=ChcDOcnuYoDRDr4FUDYmdltCvT11QnMwHzo7tHH5EDbzJCpsgz2NJwGs7jVfAhMY02
         YapKlA/2HfZmTOkLxH6UXoTFIZsjYkfJF98kAWMuukKh1Nzl9I9QN/gaGSBAsYxXvcHg
         6E9rqkIgjsjfTNQ+QvkCk1rVvUB8V3CIsAW/qAplU8vAnV/0JZEWAiCcJss85U3uq+fE
         hB78ghTIohcfXn32Q0AZ3NuyjXSJXxSfAJvoaQmQvKO1I6qPdZm/qJZtUJn6n2e08d4b
         U9isiNyIdZXA1ZCd2Uxo1m/8P8ZNNJFBeE1yAzSARszo2w1j3LnfAW5Tv7VsCmJXfTIb
         TG+g==
X-Gm-Message-State: ANoB5pmUDfLQ6L3H17nOftvaWsKp8LqCtl8NoWVZqn1d+3xpuyKZ+R2v
        GqRppOJ9hzucjdIvmkujNHRNXYZGFdnTrw==
X-Google-Smtp-Source: AA0mqf4JZfZ3LWoCQtJMqxBg6SmLvwkVN+Sdf13XwG7Ny/ba5/iEFawayl5MxPq4Y2m/1Ou5lXvWSQ==
X-Received: by 2002:a17:906:6892:b0:7c1:637:585d with SMTP id n18-20020a170906689200b007c10637585dmr1849283ejr.0.1670506527532;
        Thu, 08 Dec 2022 05:35:27 -0800 (PST)
Received: from skbuf ([188.26.185.87])
        by smtp.gmail.com with ESMTPSA id 6-20020a170906310600b00738795e7d9bsm9702341ejx.2.2022.12.08.05.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 05:35:27 -0800 (PST)
Date:   Thu, 8 Dec 2022 15:35:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20221208133524.uiqt3vwecrketc5y@skbuf>
References: <20221205185908.217520-1-netdev@kapio-technology.com>
 <20221205185908.217520-4-netdev@kapio-technology.com>
 <Y487T+pUl7QFeL60@shredder>
 <580f6bd5ee7df0c8f0c7623a5b213d8f@kapio-technology.com>
 <20221207202935.eil7swy4osu65qlb@skbuf>
 <1b0d42df6b3f2f17f77cfb45cf8339da@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b0d42df6b3f2f17f77cfb45cf8339da@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 01:28:27PM +0100, netdev@kapio-technology.com wrote:
> On 2022-12-07 21:29, Vladimir Oltean wrote:
> > On Tue, Dec 06, 2022 at 05:36:42PM +0100, netdev@kapio-technology.com wrote:
> > > > I was under the impression that we agreed that the locking change will
> > > > be split to a separate patch.
> > > 
> > > Sorry, I guess that because of the quite long time that has passed as I
> > > needed to get this FID=0 issue sorted out, and had many other different
> > > changes to attend, I forgot.
> > 
> > Well, at least you got the FID=0 issue sorted out... right?
> > What was the cause, what is the solution?
> 
> Well I got it sorted out in the way that I have identified that it is the
> ATU op that fails some times. I don't think there is anything that can be
> done about that, other than what I do and let the interrupt routing return
> an error.

Yikes. But why would you call that "sorted out", though? Just to make it
appear as though you really spent some time on it, and use it as an
excuse for something else?

> it is the ATU op that fails some times.

Let's start with the assumption that this is correct. A person with
critical thinking will ask "can I prove that it is?".

If the ATU operation fails sometimes, I would expect that it always
fails in the same way, by returning FID 0, where 0 is some kind of
"invalid" value.

But if FID 0 is actually FID_STANDALONE, then you'd read FID_STANDALONE
even if you change the value of FID_STANDALONE in the driver to
something else, like 1.

Something ultra hackish like this will install VLAN 3050 as first VID in
the switch, and that will gain FID 0. Then, MV886XXX_VID_STANDALONE will
gain FID 1. So we need to adjust the definitions.

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index ccfa4751d3b7..5923cbb172f9 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3410,9 +3410,15 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	if (err)
 		return err;
 
+	err = mv88e6xxx_port_vlan_join(chip, port, 3050,
+				       MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_UNMODIFIED,
+				       false);
+	if (err)
+		return err;
+
 	/* Bind MV88E6XXX_VID_STANDALONE to MV88E6XXX_FID_STANDALONE by
 	 * virtue of the fact that mv88e6xxx_atu_new() will pick it as
-	 * the first free FID. This will be used as the private PVID for
+	 * the second free FID. This will be used as the private PVID for
 	 * unbridged ports. Shared (DSA and CPU) ports must also be
 	 * members of this VID, in order to trap all frames assigned to
 	 * it to the CPU.
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index e693154cf803..48d4db4f2adf 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -22,8 +22,8 @@
 #define MV88E6XXX_N_FID		4096
 #define MV88E6XXX_N_SID		64
 
-#define MV88E6XXX_FID_STANDALONE	0
-#define MV88E6XXX_FID_BRIDGED		1
+#define MV88E6XXX_FID_STANDALONE	1
+#define MV88E6XXX_FID_BRIDGED		2
 
 /* PVT limits for 4-bit port and 5-bit switch */
 #define MV88E6XXX_MAX_PVT_SWITCHES	32

Now back to running the ./bridge_locked_port.sh selftest. One can now
see that whereas before, the errors we got from time to time with FID 0
are now reported with FID 1.

So it is MV88E6XXX_FID_STANDALONE, after all, not just 0.

So why, then? And most importantly, when in the selftest does this
problem occur, and as a result of which traffic?

If you actually open the selftest and put some prints in the areas of
the failure, you might be tempted to think that it's the "ping_do $h1 192.0.2.2"
command that causes it.

locked_port_mab()
{
	RET=0
	check_port_mab_support || return 0

	ping_do $h1 192.0.2.2
	check_err $? "Ping did not work before locking port"

	bridge link set dev $swp1 learning on locked on

	ping_do $h1 192.0.2.2
	check_fail $? "Ping worked on a locked port without an FDB entry"

	bridge fdb get `mac_get $h1` br br0 vlan 1 &> /dev/null
	check_fail $? "FDB entry created before enabling MAB"

	bridge link set dev $swp1 learning on locked on mab on

	set -x

	ping_do $h1 192.0.2.2
	check_fail $? "Ping worked on MAB enabled port without an FDB entry"

	set +x
	bash

	bridge fdb get `mac_get $h1` br br0 vlan 1 | grep "dev $swp1" | grep -q "locked"
	check_err $? "Locked FDB entry not created"

	bridge fdb replace `mac_get $h1` dev $swp1 master static

	ping_do $h1 192.0.2.2
	check_err $? "Ping did not work after replacing FDB entry"

	bridge fdb get `mac_get $h1` br br0 vlan 1 | grep "dev $swp1" | grep -q "locked"
	check_fail $? "FDB entry marked as locked after replacement"

	bridge fdb del `mac_get $h1` dev $swp1 master
	bridge link set dev $swp1 learning off locked off mab off

	log_test "Locked port MAB"
}

"Interesting", you might say. So stop the selftest execution there, and
run that ping again, and again, and again.

But the packets from $h1 consistently get classified to the correct FID
(the FID of the bridge port's VLAN-aware PVID).

But from time to time, those ATU errors with FID_STANDALONE keep popping up.
Strangely, it doesn't seem to be related to the ping command, at all, in
that the errors appear even while there's no pinging going on.

And then you realize, but hey, there's also a VLAN interface in the
network, created by "vlan_create $h1 100 v$h1 198.51.100.1/24".
And VID 100, at the time of the locked_port_mab() selftest, is not
present in the bridge VLAN database of port $h2.

So instead of
	ping_do $h1 192.0.2.2

why don't we try to do

	ping_do $h1.100 198.51.100.2

and actually ping over that VLAN interface?

And surprise surprise, now every packet with VID 100 gets classified to
FID_STANDALONE, and the problem is 100% reproducible.

The reverse is also true. You delete the "vlan_create" commands and you
skip the selftests that use the $h1.100 interface, and the problem goes
away.

Then, the next step is opening the documentation. If you look at Figure 23
"Relationship between VTU, STU and ATU", it will say that "the port's
Default FID is used if 802.1Q is disabled on the port or if the VID
assigned to the frame points to an empty VTU entry".

VID 100 indeed points to an empty VTU entry.

The port Default FID is set with this call:

	/* Port based VLAN map: give each port the same default address
	 * database, and allow bidirectional communication between the
	 * CPU and DSA port(s), and the other ports.
	 */
	err = mv88e6xxx_port_set_fid(chip, port, MV88E6XXX_FID_STANDALONE);
	if (err)
		return err;

So it appears that frames which get a VTU miss will still also cause an
ATU miss, and that's what you're seeing.

The solution would be to acknowledge this fact, and not print any error
message from the ATU IRQ handler for unknown FID/VID, which would just
alarm the user.

What I wanted to say with this is that it doesn't take a mad scientist
to figure this stuff out, just somebody who is motivated not to throw
half assed stuff over the fence to the mainline kernel, and just call it
a day when his project is over. I don't even interact with Marvell
hardware on a day to day basis, what I know is just information gathered
during patch review, and I could still figure out what's going on.

There's actually a deeper problem which concerns me more. I'm extremely
fed up with seeing this patch set progress so slowly, to the point where
I've considered a few times to just say fsck it, it's good enough, it's
not going to get better in your hands, let it be merged, and I'll take a
second look when I'll have some time to spare and I'll clean up what I
can. Now with Ido's help for the software bridge and MAB offload part,
the patch set is really so small and so close to getting accepted, that
I don't see what's holding you up, really. The review comments are
absolutely actionable. My dilemma is that I don't think it's okay that
there exists this "merge patch set through reviewer exhaustion" loophole.
But on the other hand, if as a reviewer I don't want that to happen,
I have to waste my time with people who simply don't want to use their
critical thinking, test on actual hardware what they've done, find
problems that they didn't want to tackle. This is also the reason why I
sent the tracepoints patch set, which I really wanted *you* to do, not
later than the MAB/locked port support itself. I find the current state
of your patch set fairly unusable from the perspective of a user who
uses a serial console. But I can't waste an unlimited amount of time,
I have other stuff to do, too. I hope we can find a compromise where you
can be more responsive to what you're being told during review.

Thanks for listening.
