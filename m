Return-Path: <netdev+bounces-11641-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11517733CBE
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 01:10:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B70D02818CB
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 23:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C74F98BF3;
	Fri, 16 Jun 2023 23:10:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FB38BE7
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 23:10:33 +0000 (UTC)
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC93C3A8B
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 16:10:31 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53ff4f39c0fso737386a12.0
        for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 16:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686957031; x=1689549031;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L/jamYwOplQeOYZLfYxKh+CGvMnRpEMMthN2j3MN6wE=;
        b=s3Nt6pYcIcJRLksXEwa2HdEGY1hZHOhHP/BS1I/I47vlOWoi3n8Kb+XLRPjEE820z2
         cNt4bm9+dyFui5zK+ch/edJaWLzGiPzadJzFLkbgz6Z6pw+yovxttY2AYkJplvZAVKBf
         o7ssHHRTTyPWiN89UiBXTDcAFPEoQw7YBzv1UVarcWhtpoFSx9Oj0FpbM/K8dVSm4o/b
         gTSadISDiaVgVwJ5zmsIcFicZNLWCTGjCCrZR4nQoFru2XoOUMWZrzskT5j4il/v/diz
         xdXlo/JqRfGJVgCnGgKWrHUcvbQ8WrcXoRZCzpDDC2UMP58tEdUSx57QiQTt2kLdh73q
         9wSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686957031; x=1689549031;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=L/jamYwOplQeOYZLfYxKh+CGvMnRpEMMthN2j3MN6wE=;
        b=g1YWAeXW/RbMmoXHLpk7Bcamz3G361CKWKKnaHOjafEWsuLYRF9dknq7pX+aRViG1W
         N8G2DVk72wo1CS98liphfvIztKHHZY7qipk4kSf1FkUtG54huqzsoxVvzIZ/qIS+yCyF
         GwEN7+FgPUj9NRlyqjYRBSkNfFu6wOcxANXnGaZQc92ZzjOaMUYL+lUVym7WHpk7uxUG
         Zlxaa71eJjymqgbs9tg7VLdax5y5bBDGm75HIMV4c7IfWzFg+MskPrGS1kFuPrEqzjQt
         cfDfOKTja8G6sdsZmB4A9j5DGSqiUbE1JGYytgHIWdyucuOzokxMzz9a/XCm2tev+Meq
         MsiA==
X-Gm-Message-State: AC+VfDzP89uAyWPBBVlVr1UZ/tpFKC4KRjHAUhFBLOF4agWQQbyEL7Re
	Khf4IR4et/F8wsUDSlsglsyx/8U=
X-Google-Smtp-Source: ACHHUZ7sSQJVEfozBaQjfhb6SGaaUmbMlPDnGEnfi7PySMJR4WrhjWYj++ppPravXfWOf/pj9lHPOc0=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:903:1301:b0:1b1:8e8b:7f5e with SMTP id
 iy1-20020a170903130100b001b18e8b7f5emr593939plb.5.1686957031062; Fri, 16 Jun
 2023 16:10:31 -0700 (PDT)
Date: Fri, 16 Jun 2023 16:10:29 -0700
In-Reply-To: <CAKH8qBscx=SWSCL_WTMPyNPu=63OzFJcenCySds2KoV1agWW9w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com> <87cz20xunt.fsf@toke.dk>
 <CAKH8qBuAUems8a7kKJPcFvarW2jy4qTf4sAM8oUC8UHj-gE=ug@mail.gmail.com>
 <CAJ8uoz2Bx3cd7braAZjZFNYfqX0JjJzSvr4RBN=j8CiH8Ld5-w@mail.gmail.com> <CAKH8qBscx=SWSCL_WTMPyNPu=63OzFJcenCySds2KoV1agWW9w@mail.gmail.com>
Message-ID: <ZIzr5ffeHsUqppaS@google.com>
Subject: Re: [RFC bpf-next 0/7] bpf: netdev TX metadata
From: Stanislav Fomichev <sdf@google.com>
To: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: "Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?=" <toke@kernel.org>, bpf@vger.kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, 
	song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, 
	haoluo@google.com, jolsa@kernel.org, willemb@google.com, dsahern@kernel.org, 
	magnus.karlsson@intel.com, bjorn@kernel.org, maciej.fijalkowski@intel.com, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 06/16, Stanislav Fomichev wrote:
> On Fri, Jun 16, 2023 at 1:13=E2=80=AFAM Magnus Karlsson
> <magnus.karlsson@gmail.com> wrote:
> >
> > On Fri, 16 Jun 2023 at 02:09, Stanislav Fomichev <sdf@google.com> wrote=
:
> > >
> > > On Mon, Jun 12, 2023 at 2:01=E2=80=AFPM Toke H=C3=B8iland-J=C3=B8rgen=
sen <toke@kernel.org> wrote:
> > > >
> > > > Some immediate thoughts after glancing through this:
> > > >
> > > > > --- Use cases ---
> > > > >
> > > > > The goal of this series is to add two new standard-ish places
> > > > > in the transmit path:
> > > > >
> > > > > 1. Right before the packet is transmitted (with access to TX
> > > > >    descriptors)
> > > > > 2. Right after the packet is actually transmitted and we've recei=
ved the
> > > > >    completion (again, with access to TX completion descriptors)
> > > > >
> > > > > Accessing TX descriptors unlocks the following use-cases:
> > > > >
> > > > > - Setting device hints at TX: XDP/AF_XDP might use these new hook=
s to
> > > > > use device offloads. The existing case implements TX timestamp.
> > > > > - Observability: global per-netdev hooks can be used for tracing
> > > > > the packets and exploring completion descriptors for all sorts of
> > > > > device errors.
> > > > >
> > > > > Accessing TX descriptors also means that the hooks have to be cal=
led
> > > > > from the drivers.
> > > > >
> > > > > The hooks are a light-weight alternative to XDP at egress and cur=
rently
> > > > > don't provide any packet modification abilities. However, eventua=
lly,
> > > > > can expose new kfuncs to operate on the packet (or, rather, the a=
ctual
> > > > > descriptors; for performance sake).
> > > >
> > > > dynptr?
> > > >
> > > > > --- UAPI ---
> > > > >
> > > > > The hooks are implemented in a HID-BPF style. Meaning they don't
> > > > > expose any UAPI and are implemented as tracing programs that call
> > > > > a bunch of kfuncs. The attach/detach operation happen via BPF sys=
call
> > > > > programs. The series expands device-bound infrastructure to traci=
ng
> > > > > programs.
> > > >
> > > > Not a fan of the "attach from BPF syscall program" thing. These are=
 part
> > > > of the XDP data path API, and I think we should expose them as prop=
er
> > > > bpf_link attachments from userspace with introspection etc. But I g=
uess
> > > > the bpf_mprog thing will give us that?
> > > >
> > > > > --- skb vs xdp ---
> > > > >
> > > > > The hooks operate on a new light-weight devtx_frame which contain=
s:
> > > > > - data
> > > > > - len
> > > > > - sinfo
> > > > >
> > > > > This should allow us to have a unified (from BPF POW) place at TX
> > > > > and not be super-taxing (we need to copy 2 pointers + len to the =
stack
> > > > > for each invocation).
> > > >
> > > > Not sure what I think about this one. At the very least I think we
> > > > should expose xdp->data_meta as well. I'm not sure what the use cas=
e for
> > > > accessing skbs is? If that *is* indeed useful, probably there will =
also
> > > > end up being a use case for accessing the full skb?
> > >
> > > I spent some time looking at data_meta story on AF_XDP TX and it
> > > doesn't look like it's supported (at least in a general way).
> > > You obviously get some data_meta when you do XDP_TX, but if you want
> > > to pass something to the bpf prog when doing TX via the AF_XDP ring,
> > > it gets complicated.
> >
> > When we designed this some 5 - 6 years ago, we thought that there
> > would be an XDP for egress action in the "nearish" future that could
> > be used to interpret the metadata field in front of the packet.
> > Basically, the user would load an XDP egress program that would define
> > the metadata layout by the operations it would perform on the metadata
> > area. But since XDP on egress has not happened, you are right, there
> > is definitely something missing to be able to use metadata on Tx. Or
> > could your proposed hook points be used for something like this?
>=20
> Thanks for the context!
> Yes, the proposal is to use these new tx hooks to read out af_xdp
> metadata and apply it to the packet via a bunch of tbd kfuncs.
> AF_XDP and BPF programs would have to have a contract about the
> metadata layout (same as we have on rx).
>=20
> > > In zerocopy mode, we can probably use XDP_UMEM_UNALIGNED_CHUNK_FLAG
> > > and pass something in the headroom.
> >
> > This feature is mainly used to allow for multiple packets on the same
> > chunk (to save space) and also to be able to have packets spanning two
> > chunks. Even in aligned mode, you can start a packet at an arbitrary
> > address in the chunk as long as the whole packet fits into the chunk.
> > So no problem having headroom in any of the modes.
>=20
> But if I put it into the headroom it will only be passed down to the
> driver in zero-copy mode, right?
> If I do tx_desc->addr =3D packet_start, no medata (that goes prior to
> packet_start) gets copied into skb in the copy mode (it seems).
> Or do you suggest that the interface should be tx_desc->addr =3D
> metadata_start and the bpf program should call the equivalent of
> bpf_xdp_adjust_head to consume this metadata?

For copy-mode, here is what I've prototyped. That seems to work.
For zero-copy, I don't think we need anything extra (besides exposing
xsk->tx_meta_len at the hook point, tbd). Does the patch below make
sense?

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index e96a1151ec75..30018b3b862d 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -51,6 +51,7 @@ struct xdp_sock {
 	struct list_head flush_node;
 	struct xsk_buff_pool *pool;
 	u16 queue_id;
+	u8 tx_metadata_len;
 	bool zc;
 	enum {
 		XSK_READY =3D 0,
diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
index a78a8096f4ce..2374eafff7db 100644
--- a/include/uapi/linux/if_xdp.h
+++ b/include/uapi/linux/if_xdp.h
@@ -63,6 +63,7 @@ struct xdp_mmap_offsets {
 #define XDP_UMEM_COMPLETION_RING	6
 #define XDP_STATISTICS			7
 #define XDP_OPTIONS			8
+#define XDP_TX_METADATA_LEN		9
=20
 struct xdp_umem_reg {
 	__u64 addr; /* Start of packet data area */
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index cc1e7f15fa73..a95872712547 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -493,14 +493,21 @@ static struct sk_buff *xsk_build_skb(struct xdp_sock =
*xs,
 			return ERR_PTR(err);
=20
 		skb_reserve(skb, hr);
-		skb_put(skb, len);
+		skb_put(skb, len + xs->tx_metadata_len);
=20
 		buffer =3D xsk_buff_raw_get_data(xs->pool, desc->addr);
+		buffer -=3D xs->tx_metadata_len;
+
 		err =3D skb_store_bits(skb, 0, buffer, len);
 		if (unlikely(err)) {
 			kfree_skb(skb);
 			return ERR_PTR(err);
 		}
+
+		if (xs->tx_metadata_len) {
+			skb_metadata_set(skb, xs->tx_metadata_len);
+			__skb_pull(skb, xs->tx_metadata_len);
+		}
 	}
=20
 	skb->dev =3D dev;
@@ -1137,6 +1144,27 @@ static int xsk_setsockopt(struct socket *sock, int l=
evel, int optname,
 		mutex_unlock(&xs->mutex);
 		return err;
 	}
+	case XDP_TX_METADATA_LEN:
+	{
+		int val;
+
+		if (optlen < sizeof(val))
+			return -EINVAL;
+		if (copy_from_sockptr(&val, optval, sizeof(val)))
+			return -EFAULT;
+
+		if (val >=3D 256)
+			return -EINVAL;
+
+		mutex_lock(&xs->mutex);
+		if (xs->state !=3D XSK_READY) {
+			mutex_unlock(&xs->mutex);
+			return -EBUSY;
+		}
+		xs->tx_metadata_len =3D val;
+		mutex_unlock(&xs->mutex);
+		return err;
+	}
 	default:
 		break;
 	}

