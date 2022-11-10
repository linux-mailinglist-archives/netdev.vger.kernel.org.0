Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68666249FC
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 19:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiKJSww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 13:52:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbiKJSwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 13:52:49 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D211DA59
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 10:52:43 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id l6so1472390ilq.3
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 10:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MaS3U08LyNcGzLT7FX/+u25NsWbC+DcNzQ0FjjWVgB0=;
        b=I5wpQl2tuZWPGvUBhZKA7beKI9wskjEFEbyN80pJwRF6hSd+jpfMWkVZwyMmb/kQHi
         s2DQ9Fj0QtkqfQmvh/4Um1q8D/YgC4D5HYhnr50TZKUCcplDzg/k9MVqKJGW4XzZdnaa
         hsSh5P6vwL58w1lygMaAwGaK08kXx97SCbXPvj7IMo+cpBgyjaD6Utj+seDrHzfBcw5S
         Th+AJwKuZ2y8GzAgkBCSV+SIiIpY5o6Zxb1IDEMpmKc1WvW5d035/8VvOF4erj8/jVt9
         hNP7WLjCU1S2DVajU/i9ytGGZkxTEn+PXKbHzrUc//Y61fkiRLsKFevAPBNf2mgrTd5e
         N6MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MaS3U08LyNcGzLT7FX/+u25NsWbC+DcNzQ0FjjWVgB0=;
        b=u79aw7+51OKDmeFMQ+Okfv0ayfjVZKnG/l2xUKoXz4Ds7WGNkrX1hNAnhDs9QqSJ/p
         2Z3ujXIM731vEKPgEY+Urt+xhHYt4yxQ7F1cxRJ06Vot7YrIRMU21Uut6H9AJSORKK1C
         2/yx9w78Mw4tw/0dV74e57Uds9IeqFnvWsMltK7uZ0oNvXLtYXmqMBCxYK7ljpL64QYP
         GJRwLsvVjkrnN9+JHnFg8RrjxEl818xhV2NNarxX23q5l319Tdivt8azt+xu1zvpTejP
         9Q36FO4gqfLMrjTAyeBDuozIPh4zl9AK9zvEOUqA74l8O1GvK8j+Qjg+CJwGvZUE6N1O
         cMag==
X-Gm-Message-State: ACrzQf2aDZE0NrK32wIA3ibYFSfcTAs/CphKcQz5Vb2xtyUs/bCqax3g
        mBkZmGs6dwhR/uWKQW5TUGJ781TNZieEIfE3wWs53A==
X-Google-Smtp-Source: AMsMyM4l7V/phVfcs1QUfEuMPnt2QNGEdDusWFMhxKynKEl5lGw+WcBSLbT/S3+gTzTYM+6PDiGs/ffDdMCuFF6jD2s=
X-Received: by 2002:a92:4b01:0:b0:300:d5f1:c1b0 with SMTP id
 m1-20020a924b01000000b00300d5f1c1b0mr3198330ilg.133.1668106362288; Thu, 10
 Nov 2022 10:52:42 -0800 (PST)
MIME-Version: 1.0
References: <20221104032532.1615099-1-sdf@google.com> <20221104032532.1615099-5-sdf@google.com>
 <636c4514917fa_13c168208d0@john.notmuch> <CAKH8qBvS9C5Z2L2dT4Ze-dz7YBSpw52VF6iZK5phcU2k4azN5A@mail.gmail.com>
 <636c555942433_13ef3820861@john.notmuch> <CAKH8qBtiNiwbupP-jvs5+nSJRJS4DfZGEPsaYFdQcPKu+8G30g@mail.gmail.com>
 <636d37629d5c4_145693208e6@john.notmuch>
In-Reply-To: <636d37629d5c4_145693208e6@john.notmuch>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 10 Nov 2022 10:52:31 -0800
Message-ID: <CAKH8qBugxJB5i=QzNEMrZ-TVAnOTpXuWbxMjECRd5HOxPSFP5Q@mail.gmail.com>
Subject: Re: [RFC bpf-next v2 04/14] veth: Support rx timestamp metadata for xdp
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 9:39 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Stanislav Fomichev wrote:
> > On Wed, Nov 9, 2022 at 5:35 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > >
> > > Stanislav Fomichev wrote:
> > > > On Wed, Nov 9, 2022 at 4:26 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > > > >
> > > > > Stanislav Fomichev wrote:
> > > > > > xskxceiver conveniently setups up veth pairs so it seems logical
> > > > > > to use veth as an example for some of the metadata handling.
> > > > > >
> > > > > > We timestamp skb right when we "receive" it, store its
> > > > > > pointer in new veth_xdp_buff wrapper and generate BPF bytecode to
> > > > > > reach it from the BPF program.
> > > > > >
> > > > > > This largely follows the idea of "store some queue context in
> > > > > > the xdp_buff/xdp_frame so the metadata can be reached out
> > > > > > from the BPF program".
> > > > > >
> > > > >
> > > > > [...]
> > > > >
> > > > > >       orig_data = xdp->data;
> > > > > >       orig_data_end = xdp->data_end;
> > > > > > +     vxbuf.skb = skb;
> > > > > >
> > > > > >       act = bpf_prog_run_xdp(xdp_prog, xdp);
> > > > > >
> > > > > > @@ -942,6 +946,7 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
> > > > > >                       struct sk_buff *skb = ptr;
> > > > > >
> > > > > >                       stats->xdp_bytes += skb->len;
> > > > > > +                     __net_timestamp(skb);
> > > > >
> > > > > Just getting to reviewing in depth a bit more. But we hit veth with lots of
> > > > > packets in some configurations I don't think we want to add a __net_timestamp
> > > > > here when vast majority of use cases will have no need for timestamp on veth
> > > > > device. I didn't do a benchmark but its not free.
> > > > >
> > > > > If there is a real use case for timestamping on veth we could do it through
> > > > > a XDP program directly? Basically fallback for devices without hw timestamps.
> > > > > Anyways I need the helper to support hardware without time stamping.
> > > > >
> > > > > Not sure if this was just part of the RFC to explore BPF programs or not.
> > > >
> > > > Initially I've done it mostly so I can have selftests on top of veth
> > > > driver, but I'd still prefer to keep it to have working tests.
> > >
> > > I can't think of a use for it though so its just extra cycles. There
> > > is a helper to read the ktime.
> >
> > As I mentioned in another reply, I wanted something SW-only to test
> > this whole metadata story.
>
> Yeah I see the value there. Also because this is in the veth_xdp_rcv
> path we don't actually attach XDP programs to veths except for in
> CI anyways. I assume though if someone actually does use this in
> prod having an extra _net_timestamp there would be extra unwanted
> cycles.
>
> > The idea was:
> > - veth rx sets skb->tstamp (otherwise it's 0 at this point)
> > - veth kfunc to access rx_timestamp returns skb->tstamp
> > - xsk bpf program verifies that the metadata is non-zero
> > - the above shows end-to-end functionality with a software driver
>
> Yep 100% agree very handy for testing just not sure we can add code
> to hotpath just for testing.
>
> >
> > > > Any way I can make it configurable? Is there some ethtool "enable tx
> > > > timestamping" option I can reuse?
> > >
> > > There is a -T option for timestamping in ethtool. There are also the
> > > socket controls for it. So you could spin up a socket and use it.
> > > But that is a bit broken as well I think it would be better if the
> > > timestamp came from the receiving physical nic?
> > >
> > > I have some mlx nics here and a k8s cluster with lots of veth
> > > devices so I could think a bit more. I'm just not sure why I would
> > > want the veth to timestamp things off hand?
> >
> > -T is for dumping only it seems?
> >
> > I'm probably using skb->tstamp in an unconventional manner here :-/
> > Do you know if enabling timestamping on the socket, as you suggest,
> > will get me some non-zero skb_hwtstamps with xsk?
> > I need something to show how the kfunc can return this data and how
> > can this data land in xdp prog / af_xdp chunk..
>
> Take a look at ./Documentation/networking/timestamping.rst the 3.1
> section is maybe relevant. But then you end up implementing a bunch
> of random ioctls for no reason other than testing. Maybe worth doing
> though for this not sure.

Hmm, there is a call to skb_tx_timestamp in veth_xmit that I missed.
Let me see if I can make it insert skb->tstamp by turning on one of
the timestamping options you mentioned..


> Using virtio driver might be actual useful and give you a test device.
> Early XDP days I used it for testing a lot. Would require qemu to
> setup though.
