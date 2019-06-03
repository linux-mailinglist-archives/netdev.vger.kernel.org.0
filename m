Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9717325B5
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 02:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfFCAdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 20:33:40 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:33741 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfFCAdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 20:33:40 -0400
Received: by mail-pg1-f176.google.com with SMTP id h17so7264039pgv.0
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 17:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Axk3pAddM4DVVF3y+8riwBqiQl1hFLkJKxJi4K9liuY=;
        b=wzluIUjYBioOXKA/k4ufqkLCbBUmT0CpBv8rpo9NJ6rl0Lhd+UiaNHl6xB/iIaMFrP
         WsenvkehoFIf5Fi2rMtpVBj2L9Wxbn01Lekg1ZERSezczAD85OIFcPGhPT3grH4Srr7n
         dH1aUoUiwPkwbYn3f26sm8Cq6i74/4ljF5r1llbicnCjBqPO1liHV11Cim4O1YtTBIcW
         jm2ctHKORKEJ+ye5oI+PWm6UYcPTw6c/WbC0DLsbl9ocqU0pdeJ6mo6SE+prpxx1hkaz
         bDrCjDUduIAXUNqTp4r4CQ3erdJCysP64Q8kRAE3tJVJDFGK0e9LDiobzvszJh8kkkTd
         lf1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Axk3pAddM4DVVF3y+8riwBqiQl1hFLkJKxJi4K9liuY=;
        b=q4tTaJNiM6/j2803Q164WXNvL0WoxLlOhpNfnFEXOnPgws7zZoHtJhKi82ZZmClDUX
         QydRyvWXwTZAcL7Cn+SOM5N2a+U7gt8jKHkH9gViJW4TZRmVRQTQw0UR5rEKpgrzA/0h
         ScdoNIqnPMbDGrd0HKxA1yLZ8w6f8ZG30fnxUkpuXxU1Napb1Rac7ev70F+StTx7IPzt
         vSrz1fZMCAuu/9KPPn8k16RSPw+0Sh5/VqiY65XSxo+JRjGfqgFqQi+sUsyYFS1Yl6NR
         65E/y0s3tbPyr1zCdWvO5QvYXWqCJysVi4KmYUiXd1tiYqYQsJOCdBA4YbcAEDCJL3vs
         MrhQ==
X-Gm-Message-State: APjAAAXV6Nr0O38LqomawZPZqnAe01yoWviXJFIxAnxE223bK8awE/XE
        Xu7uzKfrFQSyiaTpKDpVCQvB+A==
X-Google-Smtp-Source: APXvYqxygP/xjo3Ov2qb74A/P/ttbI681/8gw/kDPhh5nqXQEcAuLo+jAOT3Iuhr+1hB25Cr/yC5Ng==
X-Received: by 2002:a62:304:: with SMTP id 4mr27743090pfd.186.1559522019018;
        Sun, 02 Jun 2019 17:33:39 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id 66sm2651999pfg.140.2019.06.02.17.33.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 02 Jun 2019 17:33:38 -0700 (PDT)
Date:   Sun, 2 Jun 2019 17:33:34 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [RFC PATCH bpf-next 6/8] libbpf: allow specifying map
 definitions using BTF
Message-ID: <20190602173334.18e68d66@cakuba.netronome.com>
In-Reply-To: <CAEf4Bza38VEh9NWTLEReAR_J0eqjsvH1a2T-0AeWqDZpE8YPfA@mail.gmail.com>
References: <20190531202132.379386-1-andriin@fb.com>
        <20190531202132.379386-7-andriin@fb.com>
        <20190531212835.GA31612@mini-arch>
        <CAEf4Bza38VEh9NWTLEReAR_J0eqjsvH1a2T-0AeWqDZpE8YPfA@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 May 2019 15:58:41 -0700, Andrii Nakryiko wrote:
> On Fri, May 31, 2019 at 2:28 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > On 05/31, Andrii Nakryiko wrote:  
> > > This patch adds support for a new way to define BPF maps. It relies on
> > > BTF to describe mandatory and optional attributes of a map, as well as
> > > captures type information of key and value naturally. This eliminates
> > > the need for BPF_ANNOTATE_KV_PAIR hack and ensures key/value sizes are
> > > always in sync with the key/value type.  
> > My 2c: this is too magical and relies on me knowing the expected fields.
> > (also, the compiler won't be able to help with the misspellings).  

I have mixed feelings, too.  Especially the key and value fields are
very non-idiomatic for C :(  They never hold any value or data, while
the other fields do.  That feels so awkward.  I'm no compiler expert,
but even something like:

struct map_def {
	void *key_type_ref;
} mamap = {
	.key_type_ref = &(struct key_xyz){},
};

Would feel like less of a hack to me, and then map_def doesn't have to
be different for every map.  But yea, IDK if it's easy to (a) resolve
the type of what key_type points to, or (b) how to do this for scalar
types.

> I don't think it's really worse than current bpf_map_def approach. In
> typical scenario, there are only two fields you need to remember: type
> and max_entries (notice, they are called exactly the same as in
> bpf_map_def, so this knowledge is transferrable). Then you'll have
> key/value, using which you are describing both type (using field's
> type) and size (calculated from the type).
> 
> I can relate a bit to that with bpf_map_def you can find definition
> and see all possible fields, but one can also find a lot of examples
> for new map definitions as well.
> 
> One big advantage of this scheme, though, is that you get that type
> association automagically without using BPF_ANNOTATE_KV_PAIR hack,
> with no chance of having a mismatch, etc. This is less duplication (no
> need to do sizeof(struct my_struct) and struct my_struct as an arg to
> that macro) and there is no need to go and ping people to add those
> annotations to improve introspection of BPF maps.

> > > Relying on BTF, this approach allows for both forward and backward
> > > compatibility w.r.t. extending supported map definition features. Old
> > > libbpf implementation will ignore fields it doesn't recognize, while new
> > > implementations will parse and recognize new optional attributes.  
> > I also don't know how to feel about old libbpf ignoring some attributes.
> > In the kernel we require that the unknown fields are zeroed.
> > We probably need to do something like that here? What do you think
> > would be a good example of an optional attribute?  
> 
> Ignoring is required for forward-compatibility, where old libbpf will
> be used to load newer user BPF programs. We can decided not to do it,
> in that case it's just a question of erroring out on first unknown
> field. This RFC was posted exactly to discuss all these issues with
> more general community, as there is no single true way to do this.
> 
> As for examples of when it can be used. It's any feature that can be
> considered optional or a hint, so if old libbpf doesn't do that, it's
> still not the end of the world (and we can live with that, or can
> correct using direct libbpf API calls).

On forward compatibility my 0.02c would be - if we want to go there 
and silently ignore fields it'd be good to have some form of "hard
required" bit.  For TLVs ABIs it can be a "you have to understand 
this one" bit, for libbpf perhaps we could add a "min libbpf version
required" section?  That kind of ties us ELF formats to libbpf
specifics (the libbpf version presumably would imply support for
features), but I think we want to go there, anyway.
