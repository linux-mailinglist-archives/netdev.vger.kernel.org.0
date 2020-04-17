Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4671E1AD9C3
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 11:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730252AbgDQJXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 05:23:50 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54777 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730200AbgDQJXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 05:23:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587115423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Udf4BcbKO3WOOBolJoFF94blllFsdg6zavhAdjxC8VQ=;
        b=EK0p7XWwwrAtTL4Blze3hFVHK7zWwSlJtaoyjJAmErEg439Igqi1H46uKOnV9+ldWDSSZx
        fMxwYSBH2lSfhR8w1KWMuYLw6FifZ4NXxf0vEBlbn7EkdglN0RcqpKjHw5CZiAKhkt41J4
        vnxEUb0x6/Myi27yDt9d2FaYQEh+yeg=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-T9NtaU7dNd63AKCcy6_p1Q-1; Fri, 17 Apr 2020 05:23:41 -0400
X-MC-Unique: T9NtaU7dNd63AKCcy6_p1Q-1
Received: by mail-lj1-f197.google.com with SMTP id o21so190375ljp.17
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 02:23:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Udf4BcbKO3WOOBolJoFF94blllFsdg6zavhAdjxC8VQ=;
        b=AbcedfKxTkUPSBwhsZoHCU7HgjF2Tu15kp0VxvKWiPtCdsT0ZVNcQET1vL19HOKwFx
         1LQQaQVFRPhO7yW934rIOBMZ9dmvr472P3i3BworJEjDN0Bdn14jsumiphbVvrNc+gkv
         07PhmAv7VedDKd6N3/UPa9/TXlXtS+VJLnfnVADFwvboY9MXb6EXb+7PgsVE+n/aBtuo
         VovgNWjjcscAVs/WJyb/WZk8Uj6IKB37M9PuwAdG4MYWSO/7FoUUnx9qxf1L3I10YB/p
         WOK9dJKNdtD0qd/7HMnQ3fj4kaJCipELojw/JjtYuAg0qruQMSR8OOyJEsSMIgUWXADl
         PdRA==
X-Gm-Message-State: AGi0PuYi0kwaNYv+gSo+3cXqGOjdcGA2fdo8BkBRmPfK7iNurUSqCTAo
        UtxW533V/qcFQsPwKWs27rqUCz/3udxRJ1ncaVp/PBOQMCkSlfpH9egxzOlUdbFWJnc1cr9dclo
        W+7DBX7P/MoXNHpks
X-Received: by 2002:a2e:9616:: with SMTP id v22mr1459985ljh.107.1587115420219;
        Fri, 17 Apr 2020 02:23:40 -0700 (PDT)
X-Google-Smtp-Source: APiQypJRaEfS7Iy5UAypUYbFtcAFOmuwdSUwuFAjjRaJ/mXfY7Xa5gqQFRBZCKLoA98KQ5HUky/C7g==
X-Received: by 2002:a2e:9616:: with SMTP id v22mr1459961ljh.107.1587115419971;
        Fri, 17 Apr 2020 02:23:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id t24sm20569437lfk.90.2020.04.17.02.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 02:23:39 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 82A67181587; Fri, 17 Apr 2020 11:23:38 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH RFC-v5 bpf-next 02/12] net: Add BPF_XDP_EGRESS as a bpf_attach_type
In-Reply-To: <0b9c1c4e-c6a3-48a1-7f0a-f7362e9a10a6@gmail.com>
References: <20200413171801.54406-1-dsahern@kernel.org> <20200413171801.54406-3-dsahern@kernel.org> <87k12fleaw.fsf@toke.dk> <0b9c1c4e-c6a3-48a1-7f0a-f7362e9a10a6@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 17 Apr 2020 11:23:38 +0200
Message-ID: <87a73alb39.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 4/16/20 8:01 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> David Ahern <dsahern@kernel.org> writes:
>>=20
>>> From: David Ahern <dahern@digitalocean.com>
>>>
>>> Add new bpf_attach_type, BPF_XDP_EGRESS, for BPF programs attached
>>> at the XDP layer, but the egress path.
>>>
>>> Since egress path will not have ingress_ifindex and rx_queue_index
>>> set, update xdp_is_valid_access to block access to these entries in
>>> the xdp context when a program is attached to egress path.
>>>
>>> Update dev_change_xdp_fd to verify expected_attach_type for a program
>>> is BPF_XDP_EGRESS if egress argument is set.
>>>
>>> The next patch adds support for the egress ifindex.
>>>
>>> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
>>> Signed-off-by: David Ahern <dahern@digitalocean.com>
>>> ---
>>>  include/uapi/linux/bpf.h       | 1 +
>>>  net/core/dev.c                 | 6 ++++++
>>>  net/core/filter.c              | 8 ++++++++
>>>  tools/include/uapi/linux/bpf.h | 1 +
>>>  4 files changed, 16 insertions(+)
>>>
>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>> index 2e29a671d67e..a9d384998e8b 100644
>>> --- a/include/uapi/linux/bpf.h
>>> +++ b/include/uapi/linux/bpf.h
>>> @@ -215,6 +215,7 @@ enum bpf_attach_type {
>>>  	BPF_TRACE_FEXIT,
>>>  	BPF_MODIFY_RETURN,
>>>  	BPF_LSM_MAC,
>>> +	BPF_XDP_EGRESS,
>>>  	__MAX_BPF_ATTACH_TYPE
>>>  };
>>>=20=20
>>> diff --git a/net/core/dev.c b/net/core/dev.c
>>> index 06e0872ecdae..e763b6cea8ff 100644
>>> --- a/net/core/dev.c
>>> +++ b/net/core/dev.c
>>> @@ -8731,6 +8731,12 @@ int dev_change_xdp_fd(struct net_device *dev, st=
ruct netlink_ext_ack *extack,
>>>  		if (IS_ERR(prog))
>>>  			return PTR_ERR(prog);
>>>=20=20
>>> +		if (egress && prog->expected_attach_type !=3D BPF_XDP_EGRESS) {
>>> +			NL_SET_ERR_MSG(extack, "XDP program in Tx path must use BPF_XDP_EGR=
ESS attach type");
>>> +			bpf_prog_put(prog);
>>> +			return -EINVAL;
>>> +		}
>>> +
>>>  		if (!offload && bpf_prog_is_dev_bound(prog->aux)) {
>>>  			NL_SET_ERR_MSG(extack, "using device-bound program without HW_MODE =
flag is not supported");
>>>  			bpf_prog_put(prog);
>>> diff --git a/net/core/filter.c b/net/core/filter.c
>>> index 7628b947dbc3..c4e0e044722f 100644
>>> --- a/net/core/filter.c
>>> +++ b/net/core/filter.c
>>> @@ -6935,6 +6935,14 @@ static bool xdp_is_valid_access(int off, int siz=
e,
>>>  				const struct bpf_prog *prog,
>>>  				struct bpf_insn_access_aux *info)
>>>  {
>>> +	if (prog->expected_attach_type =3D=3D BPF_XDP_EGRESS) {
>>> +		switch (off) {
>>> +		case offsetof(struct xdp_md, ingress_ifindex):
>>> +		case offsetof(struct xdp_md, rx_queue_index):
>>> +			return false;
>>> +		}
>>> +	}
>>> +
>>=20
>> How will this be handled for freplace programs - will they also
>> "inherit" the expected_attach_type of the programs they attach to?
>>=20
>
> not sure I understand your point. This is not the first program type to
> have an expected_attach_type; it should work the same way others do -
> e.g., cgroup program types.

When attaching an freplace prog, the verifier will update the verifier
ops it uses with those of the target XDP program (in
check_attach_btf_id()). This is what makes the freplace program get
verified as if it were itself an XDP program.

However the freplace() program itself cannot use expected_attach_type
(see check in bpf_tracing_prog_attach()). So I don't think this check
based on prog->expected_attach_type is not going to work for freplace()
programs?

-Toke

