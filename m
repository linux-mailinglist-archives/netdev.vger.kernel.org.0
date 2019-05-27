Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDB162BC44
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 00:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbfE0W4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 18:56:35 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38510 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726931AbfE0W4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 18:56:34 -0400
Received: by mail-pg1-f195.google.com with SMTP id v11so9745266pgl.5
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 15:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=P6RI3l1fBN4emHVBbfNwFsY0MoxApJj0NvjT9SiIoUI=;
        b=SguEPv1ctl7ks8LdaSWZblzcETKs87BdVUDBAph8tutTP/bhiB5+IBJcbQNGriUaRD
         ASlh9eX45Mgr4g3zci50yTcXruZsXMTWUKbRlLJiXo7G5yGmqkwDXvspYoUS3CjAuew9
         HvDkZW7koDyBTHyl448gOYvGV3w9DQrNM2DWs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=P6RI3l1fBN4emHVBbfNwFsY0MoxApJj0NvjT9SiIoUI=;
        b=czEX1UJKNzxSqbA1wQowChcDa/s1cpir919XT2TbvbIonpvuiyOSmHw2DYp9vmocMv
         0Og3IYfATQMzUpZkGvmQZpd6ZPBE1LLs+ezJtP3EXR3mLNpUg9ltboR/cm7nNUmn106g
         oI3S8afPlzXSowMEvVvlxmerIv1bIe6facYZJVZ6vrXhUgB4gCkzPGHmDlcie9kxg625
         lOC2ivzhFz3WN/tkUBAinHfGwOwdmsoYLGiLz/0tLCZuZJuXrwINlIMfj2KIWeGzoft6
         fwDgm41HBmvAbVwF/MwMkppWzYFIHOZq9hL1rqDEUUGwbTXrkk1qaqm7RngZ9RjzI23T
         Pnyw==
X-Gm-Message-State: APjAAAVpRNM/7BHR3aAol6yUBWuXLUrQ7RVhHMNS0L0yZEm3Lf+t+JnJ
        KMVjz13l9gXVMmEaqtULVp+wJg==
X-Google-Smtp-Source: APXvYqyyIFoAhLVQZ3IQictgghho6FQc7UOO7pQweWt1PqVWdv5C/elIhce54zSxBJB3ghUw6KKomA==
X-Received: by 2002:a63:6f8e:: with SMTP id k136mr129149816pgc.104.1558997794013;
        Mon, 27 May 2019 15:56:34 -0700 (PDT)
Received: from jltm109.jaalam.net ([209.139.228.33])
        by smtp.gmail.com with ESMTPSA id y17sm11809287pfn.79.2019.05.27.15.56.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 15:56:33 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH net 4/4] net/udpgso_bench_tx: audit error queue
From:   Fred Klassen <fklassen@appneta.com>
In-Reply-To: <CAF=yD-LQT7=4vvMwMa96_SFuUd5GywMoae7hGi9n6rQeuhhxuQ@mail.gmail.com>
Date:   Mon, 27 May 2019 15:56:31 -0700
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5BB184F2-6C20-416B-B2AF-A678400CFE3E@appneta.com>
References: <20190523210651.80902-1-fklassen@appneta.com>
 <20190523210651.80902-5-fklassen@appneta.com>
 <CAF=yD-KBNLr5KY-YQ1KMmZGCpYNefSJKaJkZNOwd8nRiedpQtA@mail.gmail.com>
 <879E5DA6-3A4F-4CE1-9DA5-480EE30109DE@appneta.com>
 <CAF=yD-LQT7=4vvMwMa96_SFuUd5GywMoae7hGi9n6rQeuhhxuQ@mail.gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 27, 2019, at 2:46 PM, Willem de Bruijn =
<willemdebruijn.kernel@gmail.com> wrote:
>> Also, I my v2 fix in net is still up for debate. In its current =
state, it
>> meets my application=E2=80=99s requirements, but may not meet all of =
yours.

> I gave more specific feedback on issues with it (referencing zerocopy
> and IP_TOS, say).
>=20

Unfortunately I don=E2=80=99t have a very good email setup, and I found =
a
bunch of your comments in my junk folder. That was on Saturday,
and on Sunday I spent some time implementing your suggestions.
I have not pushed the changes up yet.=20

I wanted to discuss whether or not to attach a buffer to the=20
recvmsg(fd, &msg, MSG_ERRQUEUE). Without it, I have
MSG_TRUNC errors in my msg_flags. Either I have to add
a buffer, or ignore that error flag.=20

> Also, it is safer to update only the relevant timestamp bits in
> tx_flags, rather that blanket overwrite, given that some bits are
> already set in skb_segment. I have not checked whether this is
> absolutely necessary.
>=20
 I agree. See tcp_fragment_tstamp().

I think this should work.

skb_shinfo(seg)->tx_flags |=3D
			(skb_shinfo(gso_skb)->tx_flags & =
SKBTX_ANY_TSTAMP);

>> I am still open to suggestions, but so far I don=E2=80=99t have an =
alternate
>> solution that doesn=E2=80=99t break what I need working.
>=20
> Did you see my response yesterday? I can live with the first segment.
> Even if I don't think that it buys much in practice given xmit_more
> (and it does cost something, e.g., during requeueing).
>=20

I=E2=80=99m sorry, I didn=E2=80=99t receive a response. Once again, I am =
struggling
with crappy email setup. Hopefully as of today my junk mail filters are
set up properly.

I=E2=80=99d like to see that comment. I have been wondering about =
xmit_more
myself. I don=E2=80=99t think it changes anything for software =
timestamps,
but it may with hardware timestamps.

I have service contracts with Intel and Mellanox. I can open up a ticket
with them to see exactly when the timestamp is taken. I believe you
mentioned before that this is vendor specific.

> It is not strictly necessary, but indeed often a nice to have. We
> generally reference by SHA1, so wait with submitting the test until
> the fix is merged. See also the ipv6 flowlabel test that I just sent
> for one example.

Thanks. I will hold off with the test until I get a final fix in net, =
and I=E2=80=99ll use
your example.

>> Below is a sample output of the
>> test, including a failure on IPv6 TCP Zerocopy audit (a failure that =
may
>> lead to a memory leak).
>=20
> Can you elaborate on this suspected memory leak?

A user program cannot free a zerocopy buffer until it is reported as =
free.
If zerocopy events are not reported, that could be a memory leak.

I may have a fix. I have added a -P option when I am running an audit.
It doesn=E2=80=99t appear to affect performance, and since implementing =
it I have
received all error messages expected for both timestamp and zerocopy.

I am still testing.=20

>> I wanted to review the report with you before
>> I push up the v2 patch into net-next.
>>=20
>> Are these extra tests what you were expecting? Is it OK that it =
doesn=E2=80=99t
>> flow well?
>=20
> Do you mean how the output looks? That seems fine.
>=20

Good. Thanks.

>> Also, there is a failure about every 3rd time I run it,
>> indicating that some TX or Zerocopy messages are lost. Is that OK?
>=20
> No that is not. These tests are run in a continuous test
> infrastructure. We should try hard to avoid flakiness.
>=20

As per above comment, I think I removed the flakiness. I will run
overnight to confirm.

> If this intermittent failure is due to a real kernel bug, please move
> that part to a flag (or just comment out) to temporarily exclude it
> from continuous testing.
>=20
> More commonly it is an issue with the test itself. My SO_TXTIME test
> from last week depends on timing, which has me somewhat worried when
> run across a wide variety of (likely virtualized) platforms. I
> purposely chose large timescales to minimize the risk.
>=20
> On a related note, tests run as part of continuous testing should run
> as briefly as possible. Perhaps we need to reduce the time per run to
> accommodate for the new variants you are adding.
>=20

I could reduce testing from 4 to 2 seconds. Anything below that and I
miss some reports. When I found flakey results, I found I could =
reproduce
them in as little as 1 second.
>> Summary over 4.000 seconds...
>> sum tcp tx:   6921 MB/s     458580 calls (114645/s)     458580 msgs =
(114645/s)
>> ./udpgso_bench_tx: Unexpected number of Zerocopy completions:    =
458580 expected    458578 received
>=20
> Is this the issue you're referring to? Good catch. Clearly this is a
> good test to have :) That is likely due to some timing issue in the
> test, e.g., no waiting long enough to harvest all completions. That is
> something I can look into after the code is merged.

Thanks.

Should the test have failed at this point? I did return an error(), but
the script kept running.

As stated, I don=E2=80=99t want to push up until I have tested more =
fully, and
the fix is accepted (which requires a v3). If you want to review what
I have, I can push it up now with the understanding that I may still
fine tune things.=20

