Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4E08EC93F
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 20:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfKATvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 15:51:55 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39590 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbfKATvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 15:51:55 -0400
Received: by mail-lj1-f196.google.com with SMTP id y3so11381023ljj.6
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 12:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version;
        bh=5ha11ZVkcxZ26lpTg0eOSwyU3b6PXye9IzhfITxqsys=;
        b=MsefNbDbNw/+ubsvVPmNC1TQJN5WyAjshdy8W5cUPMaHJmo/yFD55kxLnopLXRo8U7
         pnkZ5EvEQsY7I9taHenM3OYadlDn6gT26H33wNf7+CgPJ9URtlwxfpimsDv2ez1KlQIw
         zsQJdkdoakzmDoKqFcAAoDbLwnrOaEOtJ72ibB3Qlj5q0VrjzVeEsaaMuH8fBTAZiWHN
         iorSgud3kpoOgzOAfhYABj69bF/N+2WiM6LRHK9Ver0P7s5+onLbYqkG3MupMOPR36Rj
         Zr/f9y0QCrjnEpuBhGOTWVPzydPfigV/NY0dSm9SG31QuHx4qmGV/Q50PQuGtfTqZApD
         22Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version;
        bh=5ha11ZVkcxZ26lpTg0eOSwyU3b6PXye9IzhfITxqsys=;
        b=X11yGY/8yBIIg4j58np1+Qya+LSof2od68aXuRNz7aVu0+48ZGafCJwJRmlMn/Cx2x
         wXf2M40IOC8i3SV5NLr+UBJH6dNsJJIdxcGo3CIFHQUWLNU0Yt3cOWpFIGYvxk4bhaVd
         lLvSc0/Q71Pb+I6nwlYL4zV26SyWrkgb/SNMRLisKiaP1jKu8cODTAiQW9nrw5d8zK5e
         EUUUOtuXBE0LikJ290+ubLetCQGBpnnTtXEd9N5MXBBPp/6gWz76O99lxgieGFlJKt0+
         n4HvgpXEm/DvpFvt7CN+YtnvhF2jKucxjLgRf5GE6+86AA66BYmgAEOqL8rI6D4/bdSe
         Ddkg==
X-Gm-Message-State: APjAAAWRNKg2MezvEfRKYAKrPnQww0aHWHL/spQ9d335Onv8W4Sszybl
        z1HidYIthj7X86AmUq+OxEXRig==
X-Google-Smtp-Source: APXvYqwWyKrngAw3GUgVjrTW/vPRUzJgh6qNmbG8mvTpwFdL86YoU7neKf95TDIpirLajjt+fNX9rQ==
X-Received: by 2002:a2e:a16d:: with SMTP id u13mr9747217ljl.214.1572637911013;
        Fri, 01 Nov 2019 12:51:51 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s26sm919319ljj.12.2019.11.01.12.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 12:51:50 -0700 (PDT)
Date:   Fri, 1 Nov 2019 12:51:39 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, borisp@mellanox.com,
        aviadye@mellanox.com, daniel@iogearbox.net,
        syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com,
        syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@kernel.org>,
        herbert@gondor.apana.org.au, glider@google.com,
        linux-crypto@vger.kernel.org
Subject: Re: [oss-drivers] Re: [PATCH net] net/tls: fix sk_msg trim on
 fallback to copy mode
Message-ID: <20191101125139.77eb57aa@cakuba.netronome.com>
In-Reply-To: <20191101102238.7f56cb84@cakuba.netronome.com>
References: <20191030160542.30295-1-jakub.kicinski@netronome.com>
        <5dbb5ac1c208d_4c722b0ec06125c0cc@john-XPS-13-9370.notmuch>
        <20191031152444.773c183b@cakuba.netronome.com>
        <5dbbb83d61d0c_46342ae580f765bc78@john-XPS-13-9370.notmuch>
        <20191031215444.68a12dfe@cakuba.netronome.com>
        <5dbc48ac3a8cc_e4e2b12b10265b8a1@john-XPS-13-9370.notmuch>
        <20191101102238.7f56cb84@cakuba.netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/y928O4Z.I7HqST5oCUO3V22"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--MP_/y928O4Z.I7HqST5oCUO3V22
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Fri, 1 Nov 2019 10:22:38 -0700, Jakub Kicinski wrote:
> > > +		msg->sg.copybreak =3D 0;
> > > +	} else if (sk_msg_iter_dist(msg->sg.start, msg->sg.curr) >
> > > +		   sk_msg_iter_dist(msg->sg.end, msg->sg.curr)) {
> > > +		sk_msg_iter_var_prev(i);   =20
> >=20
> > I suspect with small update to dist logic the special case could also
> > be dropped here. But I have a preference for my example above at the
> > moment. Just getting coffee now so will think on it though. =20
>=20
> Oka, I like the dist thing, I thought that's where you were going in
> your first email :)
>=20
> I need to do some more admin, and then I'll probably write a unit test
> for this code (use space version).. So we can test either patch with it.

Attaching my "unit test", you should be able to just replace
sk_msg_trim() with yours and re-run. That said my understanding of the
expected geometry of the buffer may not be correct :)

The patch I posted yesterday, with the small adjustment to set curr to
start on empty message passes that test, here it is again:

----->8-----

=46rom 953df5bc0992e31a2c7863ea8b8e490ba7a07356 Mon Sep 17 00:00:00 2001
From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Tue, 29 Oct 2019 20:20:49 -0700
Subject: [PATCH net] net/tls: fix sk_msg trim on fallback to copy mode

sk_msg_trim() tries to only update curr pointer if it falls into
the trimmed region. The logic, however, does not take into the
account pointer wrapping that sk_msg_iter_var_prev() does nor
(as John points out) the fact that msg->sg is a ring buffer.

This means that when the message was trimmed completely, the new
curr pointer would have the value of MAX_MSG_FRAGS - 1, which is
neither smaller than any other value, nor would it actually be
correct.

Special case the trimming to 0 length a little bit and rework
the comparison between curr and end to take into account wrapping.

This bug caused the TLS code to not copy all of the message, if
zero copy filled in fewer sg entries than memcopy would need.

Big thanks to Alexander Potapenko for the non-KMSAN reproducer.

v2:
 - take into account that msg->sg is a ring buffer (John).

Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
Suggested-by: John Fastabend <john.fastabend@gmail.com>
Reported-by: syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com
Reported-by: syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 include/linux/skmsg.h |  9 ++++++---
 net/core/skmsg.c      | 20 +++++++++++++++-----
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index e4b3fb4bb77c..ce7055259877 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -139,6 +139,11 @@ static inline void sk_msg_apply_bytes(struct sk_psock =
*psock, u32 bytes)
 	}
 }
=20
+static inline u32 sk_msg_iter_dist(u32 start, u32 end)
+{
+	return end >=3D start ? end - start : end + (MAX_MSG_FRAGS - start);
+}
+
 #define sk_msg_iter_var_prev(var)			\
 	do {						\
 		if (var =3D=3D 0)				\
@@ -198,9 +203,7 @@ static inline u32 sk_msg_elem_used(const struct sk_msg =
*msg)
 	if (sk_msg_full(msg))
 		return MAX_MSG_FRAGS;
=20
-	return msg->sg.end >=3D msg->sg.start ?
-		msg->sg.end - msg->sg.start :
-		msg->sg.end + (MAX_MSG_FRAGS - msg->sg.start);
+	return sk_msg_iter_dist(msg->sg.start, msg->sg.end);
 }
=20
 static inline struct scatterlist *sk_msg_elem(struct sk_msg *msg, int whic=
h)
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index cf390e0aa73d..f87fde3a846c 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -270,18 +270,28 @@ void sk_msg_trim(struct sock *sk, struct sk_msg *msg,=
 int len)
=20
 	msg->sg.data[i].length -=3D trim;
 	sk_mem_uncharge(sk, trim);
+	/* Adjust copybreak if it falls into the trimmed part of last buf */
+	if (msg->sg.curr =3D=3D i && msg->sg.copybreak > msg->sg.data[i].length)
+		msg->sg.copybreak =3D msg->sg.data[i].length;
 out:
-	/* If we trim data before curr pointer update copybreak and current
-	 * so that any future copy operations start at new copy location.
+	sk_msg_iter_var_next(i);
+	msg->sg.end =3D i;
+
+	/* If we trim data a full sg elem before curr pointer update
+	 * copybreak and current so that any future copy operations
+	 * start at new copy location.
 	 * However trimed data that has not yet been used in a copy op
 	 * does not require an update.
 	 */
-	if (msg->sg.curr >=3D i) {
+	if (!msg->sg.size) {
+		msg->sg.curr =3D msg->sg.start;
+		msg->sg.copybreak =3D 0;
+	} else if (sk_msg_iter_dist(msg->sg.start, msg->sg.curr) >
+		   sk_msg_iter_dist(msg->sg.end, msg->sg.curr)) {
+		sk_msg_iter_var_prev(i);
 		msg->sg.curr =3D i;
 		msg->sg.copybreak =3D msg->sg.data[i].length;
 	}
-	sk_msg_iter_var_next(i);
-	msg->sg.end =3D i;
 }
 EXPORT_SYMBOL_GPL(sk_msg_trim);
=20
--=20
2.23.0


--MP_/y928O4Z.I7HqST5oCUO3V22
Content-Type: text/x-c++src
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=ut.c

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef unsigned int u32;

struct sock;

#define MAX_MSG_FRAGS 5

#define WARN_ON(cond)	fprintf(stderr, "WARNING %s:%d\n", __func__, __LINE__)

#define sk_msg_iter_var_prev(var)			\
	do {						\
		if (var == 0)				\
			var = MAX_MSG_FRAGS - 1;	\
		else					\
			var--;				\
	} while (0)

#define sk_msg_iter_var_next(var)			\
	do {						\
		var++;					\
		if (var == MAX_MSG_FRAGS)		\
			var = 0;			\
	} while (0)

struct scatterlist {
	u32				length;
};

struct sk_msg_sg {
	u32				start;
	u32				curr;
	u32				end;
	u32				size;
	u32				copybreak;
	/* The extra element is used for chaining the front and sections when
	 * the list becomes partitioned (e.g. end < start). The crypto APIs
	 * require the chaining.
	 */
	struct scatterlist		data[MAX_MSG_FRAGS + 1];
};

struct sk_msg {
	struct sk_msg_sg		sg;
};

static void sk_msg_free_elem(struct sock *sk, struct sk_msg *msg, int i, bool a)
{
	msg->sg.data[i].length = 0;
}

static inline void sk_mem_uncharge() {}

static inline u32 sk_msg_iter_dist(u32 start, u32 end)
{
	return end >= start ? end - start : end + (MAX_MSG_FRAGS - start);
}

void sk_msg_trim(struct sock *sk, struct sk_msg *msg, int len)
{
	int trim = msg->sg.size - len;
	u32 i = msg->sg.end;

	if (trim <= 0) {
		WARN_ON(trim < 0);
		return;
	}

	sk_msg_iter_var_prev(i);
	msg->sg.size = len;
	while (msg->sg.data[i].length &&
	       trim >= msg->sg.data[i].length) {
		trim -= msg->sg.data[i].length;
		sk_msg_free_elem(sk, msg, i, true);
		sk_msg_iter_var_prev(i);
		if (!trim)
			goto out;
	}

	msg->sg.data[i].length -= trim;
	sk_mem_uncharge(sk, trim);
	/* Adjust copy break if it falls into the trimmed part of last buf */
	if (msg->sg.curr == i && msg->sg.copybreak > msg->sg.data[i].length)
		msg->sg.copybreak = msg->sg.data[i].length;
out:
	sk_msg_iter_var_next(i);
	msg->sg.end = i;

	/* If we trim data a full sg elem before curr pointer update
	 * copybreak and current so that any future copy operations
	 * start at new copy location.
	 * However trimed data that has not yet been used in a copy op
	 * does not require an update.
	 */
	if (!msg->sg.size) {
		msg->sg.curr = msg->sg.start;
		msg->sg.copybreak = 0;
	} else if (sk_msg_iter_dist(msg->sg.start, msg->sg.curr) >
		   sk_msg_iter_dist(msg->sg.end, msg->sg.curr)) {
		sk_msg_iter_var_prev(i);
		msg->sg.curr = i;
		msg->sg.copybreak = msg->sg.data[i].length;
	}
}

#define NOPAREN(...) __VA_ARGS__

static void dump_msg(const char *str, struct sk_msg *msg, const char *end)
{
	int i;

	fprintf(stderr, "%s start:%u curr:%u end:%u cb:%3u size:%4u   ",
		str, msg->sg.start, msg->sg.curr, msg->sg.end,
		msg->sg.copybreak, msg->sg.size);
	for (i = 0; i < MAX_MSG_FRAGS; i++)
		fprintf(stderr, " %3u", msg->sg.data[i].length);
	fprintf(stderr, "%s", end);
}

#define test_one(_as, _ac, _acb, _len, _bc, _bcb, _be, _ad...)		\
	do {								\
		struct sk_msg msg = {					\
			.sg = {						\
				.start		= (_as),		\
				.curr		= (_ac),		\
				.end		= 0,			\
				.copybreak	= (_acb),		\
			},						\
		};							\
		int in_lens[] = { _ad };				\
		struct sk_msg omsg = {					\
			.sg = {						\
				.start		= (_as),		\
				.curr		= (_bc),		\
				.end		= (_be),		\
				.copybreak	= (_bcb),		\
			},						\
		};							\
		int i;							\
									\
		for (i = 0; i < sizeof(in_lens)/sizeof(in_lens[0]); i++) { \
			int var = (i + msg.sg.start) % MAX_MSG_FRAGS;	\
									\
			msg.sg.data[var].length = in_lens[i];		\
			msg.sg.size += in_lens[i];			\
		}							\
		msg.sg.end = (msg.sg.start + i) % MAX_MSG_FRAGS;	\
									\
		for (i = 0; i < sizeof(in_lens)/sizeof(in_lens[0]); i++) { \
			int var = (i + msg.sg.start) % MAX_MSG_FRAGS;	\
			int len = in_lens[i];				\
									\
			if ((_len) < omsg.sg.size + len)		\
				len = (_len) - omsg.sg.size;		\
			omsg.sg.data[var].length = len;			\
			omsg.sg.size += len;				\
		}							\
									\
		fprintf(stderr, "test #%2u ", test_ID);			\
		dump_msg("", &msg, "");					\
		sk_msg_trim(NULL, &msg, (_len));			\
									\
		if (memcmp(&msg, &omsg, sizeof(msg))) {			\
			fprintf(stderr, "\tfailed\n");			\
			dump_msg("  result", &msg, "\n");		\
			dump_msg("  expect", &omsg, "\n");		\
		} else {						\
			fprintf(stderr, "\tOKAY\n");			\
		}							\
		test_ID++;						\
} while (0)

static unsigned int test_ID;

int main()
{
	test_one(/* start */ 0, /* curr */ 0, /* copybreak */ 200,
		 /* trim */ 100,
		 /* curr */ 0, /* copybreak */ 100, /* end */ 1,
		 /* data */ 200);

	test_one(/* start */ 1, /* curr */ 1, /* copybreak */ 200,
		 /* trim */ 100,
		 /* curr */ 1, /* copybreak */ 100, /* end */ 2,
		 /* data */ 200);

	test_one(/* start */ 1, /* curr */ 1, /* copybreak */ 200,
		 /* trim */ 300,
		 /* curr */ 1, /* copybreak */ 200, /* end */ 3,
		 /* data */ 200, 200);

	test_one(/* start */ 1, /* curr */ 2, /* copybreak */ 200,
		 /* trim */ 200,
		 /* curr */ 1, /* copybreak */ 200, /* end */ 2,
		 /* data */ 200, 200, 200);

	test_one(/* start */ 1, /* curr */ 3, /* copybreak */ 200,
		 /* trim */ 200,
		 /* curr */ 1, /* copybreak */ 200, /* end */ 2,
		 /* data */ 200, 200, 200);

	test_one(/* start */ 1, /* curr */ 2, /* copybreak */ 200,
		 /* trim */ 0,
		 /* curr */ 1, /* copybreak */ 0, /* end */ 1,
		 /* data */ 200, 200, 200);

	test_one(/* start */ 1, /* curr */ 1, /* copybreak */ 200,
		 /* trim */ 0,
		 /* curr */ 1, /* copybreak */ 0, /* end */ 1,
		 /* data */ 200, 200, 200, 200, 200);

	test_one(/* start */ 1, /* curr */ 3, /* copybreak */ 100,
		 /* trim */ 0,
		 /* curr */ 1, /* copybreak */ 0, /* end */ 1,
		 /* data */ 200, 200, 200, 200, 200);

	test_one(/* start */ 1, /* curr */ 0, /* copybreak */ 200,
		 /* trim */ 0,
		 /* curr */ 1, /* copybreak */ 0, /* end */ 1,
		 /* data */ 200, 200, 200, 200, 200);

	test_one(/* start */ 1, /* curr */ 0, /* copybreak */ 200,
		 /* trim */ 900,
		 /* curr */ 0, /* copybreak */ 100, /* end */ 1,
		 /* data */ 200, 200, 200, 200, 200);

	test_one(/* start */ 1, /* curr */ 0, /* copybreak */ 200,
		 /* trim */ 900,
		 /* curr */ 0, /* copybreak */ 100, /* end */ 1,
		 /* data */ 200, 200, 200, 200, 200);

	test_one(/* start */ 0, /* curr */ 1, /* copybreak */ 0,
		 /* trim */ 100,
		 /* curr */ 0, /* copybreak */ 100, /* end */ 1,
		 /* data */ 200);

	test_one(/* start */ 1, /* curr */ 2, /* copybreak */ 0,
		 /* trim */ 100,
		 /* curr */ 1, /* copybreak */ 100, /* end */ 2,
		 /* data */ 200);

	return 0;
}

--MP_/y928O4Z.I7HqST5oCUO3V22--
