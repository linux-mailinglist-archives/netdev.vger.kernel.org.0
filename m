Return-Path: <netdev+bounces-583-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D93CB6F847A
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 16:03:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 804F6281037
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 14:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BC29156DA;
	Fri,  5 May 2023 14:03:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB2F33D8
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 14:03:56 +0000 (UTC)
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D82716350
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 07:03:46 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-24def967c6cso291199a91.1
        for <netdev@vger.kernel.org>; Fri, 05 May 2023 07:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683295425; x=1685887425;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PRwGU2Eppjv8VMaeqhJS9cTevPdk11KIx5eCwytZNVQ=;
        b=TA/ker5O0TdUfOfh6QzSLxzpVRXQAiAUrn3z0KUN/uRAiBeyRhLMhRn/fm4dD0TuN2
         ZHIPEU4GcJ+tNWo+ipmXZ2M+uhujuu3MV01VEJyOzvVSQPRWBjKbp9anzF4QrlQlKkwn
         s1JNEn5eaxUo8t0xuyIfyjjHnELJc+9/goCaVc0xFSEaCiIT9TjE2BItuzA+5k+zWOCi
         AUsnt4Ziv1kvuck/Y0qACSHh/2885NN/8O7XjJ9gTa8MuFV7EwiT9ieFOSUfUWYGAlrQ
         IJ63Dqrb51dVUW7qU5qt+DdpO+ZyP9h5H6+McfAdH6O9xuRQzC2JdfP+3wsv6TdsPRHh
         6s7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683295425; x=1685887425;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PRwGU2Eppjv8VMaeqhJS9cTevPdk11KIx5eCwytZNVQ=;
        b=IK5XJNrRy81mCiYhbK694eBtAuCirDnAmfYxkx74IB703FRSwfzWTPfF+yd+HSp18W
         HDyjz/7iFujYgjRe+8eS90bW74vpCLARB2w4pIrbeaKcccQNDe8KN2r8+rS3VKVEpfiq
         IcIpbVKqG//6iSBlBxnnTaa3PTwjh5N9fYTlI1EegUO954ibX4GMMKqA2Ps4R3pbD/P/
         TPaQbNOYJGWuCxTh8XcA+D1vHQJEQgW88sTy53/C71ooVFzrLxnfkEra4Ak1RwbcRaFG
         0YZFGiJ3GUAtBEe1+BSMCrnqpFLLN/krclXdqbRmv7untIUNcnojPsue4D9TwDsQg4rV
         WxVg==
X-Gm-Message-State: AC+VfDxFlfIsJVSw6RNB24qbVrwyGKMismpsoHVYKZ9Ui5pPvmwl3P7M
	KYxTDEmBo1VpnIF0cPbuRsdqA6fvewsK7cUU8lyochmjD14=
X-Google-Smtp-Source: ACHHUZ5ldolxSJ5wysQp6OxfX7sSxtxu8pRFj+azO6SN4/5Iv+JggM8pXR7O7WI0UjMCqURTglwFS7M103moC1cjnZ0=
X-Received: by 2002:a17:90a:19c4:b0:24e:1c72:c096 with SMTP id
 4-20020a17090a19c400b0024e1c72c096mr1409182pjj.4.1683295425334; Fri, 05 May
 2023 07:03:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOMZO5AMOVAZe+w3FiRO-9U98Foba5Oy4f_C0K7bGNxHA1qz_w@mail.gmail.com>
 <7b8243a3-9976-484c-a0d0-d4f3debbe979@lunn.ch> <CAOMZO5DXH1wS9YYPWXYr-TvM+9Tj8F0bY0_kd_EAjrcCpEJJ7A@mail.gmail.com>
 <CAOMZO5Dk44QSTg2rh_HPHXg=H7BJ+x1h95M+t8nr2CLW+8pABw@mail.gmail.com> <5e21a8da-b31f-4ec8-8b46-099af5a8b8af@lunn.ch>
In-Reply-To: <5e21a8da-b31f-4ec8-8b46-099af5a8b8af@lunn.ch>
From: Fabio Estevam <festevam@gmail.com>
Date: Fri, 5 May 2023 11:03:34 -0300
Message-ID: <CAOMZO5CzkzHgxE4PwQsgSCsNYnMcOV5K5N=26c_6hqN6YSA3HA@mail.gmail.com>
Subject: Re: mv88e6320: Failed to forward PTP multicast
To: Andrew Lunn <andrew@lunn.ch>
Cc: Vladimir Oltean <olteanv@gmail.com>, Florian Fainelli <f.fainelli@gmail.com>, 
	=?UTF-8?Q?Steffen_B=C3=A4tz?= <steffen@innosonix.de>, 
	netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Andrew,

On Fri, May 5, 2023 at 10:02=E2=80=AFAM Andrew Lunn <andrew@lunn.ch> wrote:

> I notice you have an extra, unneeded, down/up in you script. Is that
> required to produce the problem?

No, this sequence is not required to reproduce the problem.

> So some background....
>
> I mention 01-80-C2-00-00-0E because the switch looks for specific
> types of frames and forwards them to the CPU, independent of the
> status of the port. So for example, BPDUs used for spanning tree, use
> a MAC address in the range 01-80-C2-00-00-XX, so the switch forwards
> them to the CPU. PTP using 01-80-C2-00-00-0E would also match and get
> forwarded to the CPU.
>
> You are using 01:00:5e:00:01:81, so that is just general
> multicast. The hardware matching for PTP is probably not going to
> match on that.

Yes, that may be the reason, but why doesn't the hardware filter allow
us to forward unknown multicasts (non-IGMP subscribed)? Even if we set it t=
o do
so with "mcast_flood"?

> What might also be playing a role here, maybe, is IGMP snooping. Does
> your downstream PTP client issue IGMP join requests for the group, and
> does the Linux bridge see them? If IGMP snooping is active, and there
> is no IGMP signalling, there is no need to actually forward the PTP
> frames, since nobody is interested in them. If there is a client
> interested in the traffic, you would expect to see a multicast FDB
> entry added to the switch in order that it forwards the multicast to
> the CPU. However, this does not really fit the vlan_filtering.

Yes true, but we are also testing with a third-party software
(PTPTrackHound) that does
the IGMP join, and it also fails in this case.
In any case, the "bridge -d -s mdb show" shows us always the correct
subscriptions if IGMP is active.
Further, if we disable IGMP snooping, all multicasts should be forwarded, a=
nd
still, our PTP multicast is not forwarded.

> When i look at your tcpdump traffic, i don't see a VLAN for your PTP
> traffic. So i'm assuming it is untagged. You also don't appear to be
> setting a default VLAN PVID. If you define it, untagged traffic gets
> tagged on ingress and is then handled like tagged traffic.

That was to simplify the example. It makes no difference if we add
more or less VLANs, tagged or not.

After adding a bridge and making it vlan aware, then these defaults are
applied:

# bridge vlan show
port              vlan-id
eth1              1 PVID Egress Untagged
eth2              1 PVID Egress Untagged
br0              1 PVID Egress Untagged

We can play with different VIDs, but it does not make any difference,
unfortunately.

We have tried a lot of different combinations and also tried to remove
the VLAN from the bridge and reassign it, but it makes
no difference.

Thanks

