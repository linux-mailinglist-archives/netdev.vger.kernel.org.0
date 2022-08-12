Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F5D59107E
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 14:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237708AbiHLMGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 08:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236835AbiHLMGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 08:06:23 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2108A720D;
        Fri, 12 Aug 2022 05:06:19 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id q16so633773pgq.6;
        Fri, 12 Aug 2022 05:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=hDC/jUdVYEpp7nT64PmbdcJ0mzLsVPAF89Y4iL2YZbk=;
        b=fre32HHrKnVEgSnLxQUQfSHOqUBS9X9RzHLf3cW+6kkzb1+GmjQvIheJ96cRLp8i7Z
         Rcq2R7mDps6GrYyRXUMDCYPaI0FRNfd2hLxOQWtEAZUCWmB8tFZUDSPCRdOY8x0xspQS
         RdYJSdmD+S+T+i9mxIC8rWqxC1+kykgJHexacDusT2T8Y0ttmawKM1fOTThRB+Fw9RzI
         n1091vI13eVq7IkN1phM4bT261H9DP0sCkDmcK4owd6pSNHNS3K6PyrEs07F00aBOhGH
         OwmaByUgzWa45/XMlPCfDytPLVItM7YBcCdQqLFBp+BxzSgaPHp7NISIZc9V6gPxhWqk
         JgDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=hDC/jUdVYEpp7nT64PmbdcJ0mzLsVPAF89Y4iL2YZbk=;
        b=TP0niO60hrMhhxe7/0a+X+IVGSfl/Y0gqBxtHXGmmcIimxyHAWiPSVZL+VNbvD29iC
         232NnRmoAWZvyd2uSxWj7G/hh93M8WPJ9wR6uy57E0kKYIDzHbYsVFuSy8qG8GQM+8Jp
         YvsyZNuHkrpNJ1I50aqSDWWm0jAw7Xo4CvsNW/Z2yQiZHCP8uaJ9eHRrebMau/iqus01
         yfFzie3TMOmUfoZ2+W0w1VKbuwN3fTJW2lc8UM1Vh1rDFXKG44HaEzbtmv5boCxfdpEY
         EbhaOhVZCeBZjiJErTEl+qQiFWZjJU3p9Tx8Oj/F1xD+9p0q4xERd68ZmqacPOMN/0Th
         3+Xw==
X-Gm-Message-State: ACgBeo07edJ1IF4kfIxJ+1IadUGmOj48IWG2S/SA4bylNd0Y9jTB9ZjM
        s4MQCFCjq7P8CEh0MoSRGeln8WvMsX5UrLa/Ow8A6npeByNyyPnQ
X-Google-Smtp-Source: AA6agR7/Hv2oTPPw+b0/HN3a3VCUYXPFGKLyuzFg2rEKWEFoZituDQGN/0OTQ5wQlHCRPI7Uz6P3xggMooRoxT2WTBw=
X-Received: by 2002:a63:5947:0:b0:41d:d4ea:6c87 with SMTP id
 j7-20020a635947000000b0041dd4ea6c87mr2804394pgm.528.1660305978965; Fri, 12
 Aug 2022 05:06:18 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Fri, 12 Aug 2022 05:06:06 -0700
Message-ID: <CAHo-OoxwQ3fO3brKw0MSNcQtW5Ynr8LUJoANU_TFeOAQkP1RAA@mail.gmail.com>
Subject: Query on reads being flagged as direct writes...
To:     Lina Wang <lina.wang@mediatek.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Stanislav Fomichev <sdf@google.com>,
        Thomas Graf <tgraf@suug.ch>,
        Alexei Starovoitov <ast@kernel.org>
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

From kernel/bpf/verifier.c with some simplifications (removed some of
the cases to make this shorter):

static bool may_access_direct_pkt_data(struct bpf_verifier_env *env,
const struct bpf_call_arg_meta *meta, enum bpf_access_type t)
{
  enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
  switch (prog_type) {
    /* Program types only with direct read access go here! */
    case BPF_PROG_TYPE_CGROUP_SKB: (and some others)
      if (t == BPF_WRITE) return false;
      fallthrough;
    /* Program types with direct read + write access go here! */
    case BPF_PROG_TYPE_SCHED_CLS: (and some others)
      if (meta) return meta->pkt_access;
      env->seen_direct_write = true;
      return true;
    case BPF_PROG_TYPE_CGROUP_SOCKOPT:
      if (t == BPF_WRITE) env->seen_direct_write = true;
      return true;
  }
}

why does the above set env->seen_direct_write to true even when t !=
BPF_WRITE, even for programs that only allow (per the comment) direct
read access.

Is this working correctly?  Is there some gotcha this is papering over?

Should 'env->seen_direct_write = true; return true;' be changed into
'fallthrough' so that write is only set if t == BPF_WRITE?

This matters because 'env->seen_direct_write = true' then triggers an
unconditional unclone in the bpf prologue, which I'd like to avoid
unless I actually need to modify the packet (with
bpf_skb_store_bytes)...

may_access_direct_pkt_data() has two call sites, in one it only gets
called with BPF_WRITE so it's ok, but the other one is in
check_func_arg():

if (type_is_pkt_pointer(type) && !may_access_direct_pkt_data(env,
meta, BPF_READ)) { verbose(env, "helper access to the packet is not
allowed\n"); return -EACCES; }

and I'm not really following what this does, but it seems like bpf
helper read access to the packet triggers unclone?

(side note: all packets ingressing from the rndis gadget driver are
clones due to how it deals with usb packet deaggregation [not to be
mistaken with lro/tso])

Confused...
