Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCE431D021
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 19:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhBPSUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 13:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhBPSUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 13:20:08 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDC0C061574;
        Tue, 16 Feb 2021 10:19:28 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id u20so11120857iot.9;
        Tue, 16 Feb 2021 10:19:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=VpiTqBn83H4hDZ98QsVEo+yb76dIGa+EZ9qAOcQg2QU=;
        b=cw30fOtaElI1xwCTiW5ILgzXynm7x+VYQFUekjYEnKQqYmygWtm6/NqnpTV83ua77q
         BjCjxK6p5Tc1ntGcnb+/3njyFPbGqI2o/CewZ9DdUKBpfID6wGXJnhHfOxHnr/esbm74
         rrZMWYhgxU7ZhZ+TM/FVPWdTUuan6SVhNm2CCn5F9iN0Q/aYxV4G/SPRQH7uNd7FzD2W
         1/xtkix6LdM7hUlpbIOpMf/3Gx1+sO2SengeHLtBBgzVCn77E3pPkFR3SGe2M94C4pWW
         L9ORuemC8tHO8Te4lM8rwZ6h/NS5lJHQVG6WBvx3RWTaubTgXJobf+B8P5UoK0gWlWny
         XfjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=VpiTqBn83H4hDZ98QsVEo+yb76dIGa+EZ9qAOcQg2QU=;
        b=SpDS1FT964y9YHt++Wf17Yx1MeFU2SqZYUTSYcyqmsa4znVd05CnIwcoRMCiDgHsGH
         k9xlhig6EDe0VVbCXpAQp3aly6qRd6Je9rzXLXKgZ6VDR0cnN9cOIDY9CWQY6HcdVuDU
         LI/1MqTh1WMpPXJNADm5aKL1QfhANad/b3TEclHmgXy/77kVthnalDaT2Kr9DZQTsVL3
         D+GRGt35yeuWrYaUG694pJUd9r2ZFqgFp/5RG4yBdk1AmctKepEj7h64AqZUS7NhnBTA
         hr5UP2n/cpQqHXcKpWN5rEHBav468JZWTcJQXXybawLmisx/5idyFUBezGXwJkG7rM0W
         N2hg==
X-Gm-Message-State: AOAM532nSqw4Mi6686Y8g79IySxozjIei41I1iyM6xo9Ju4z2KkDntgU
        xoXcYavkIjzlELDIjV0Xhrj9caXU/1Q=
X-Google-Smtp-Source: ABdhPJyy/5633hPR6lI3pJLl9exPJK7cSlw+2+mKBTYzGKIQX2zWYrSJWbUIUnQ3x7jLP0HeWq2bGQ==
X-Received: by 2002:a6b:2cd5:: with SMTP id s204mr18136867ios.39.1613499567815;
        Tue, 16 Feb 2021 10:19:27 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id e1sm10572864iod.17.2021.02.16.10.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 10:19:27 -0800 (PST)
Date:   Tue, 16 Feb 2021 10:19:17 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, andrii@kernel.org, toke@redhat.com,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com
Message-ID: <602c0ca5dc2d6_6b71920830@john-XPS-13-9370.notmuch>
In-Reply-To: <20210216023833.GD9572@ranger.igk.intel.com>
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-2-maciej.fijalkowski@intel.com>
 <602ade57ddb9c_3ed41208a1@john-XPS-13-9370.notmuch>
 <20210216023833.GD9572@ranger.igk.intel.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski wrote:
> On Mon, Feb 15, 2021 at 12:49:27PM -0800, John Fastabend wrote:
> > Maciej Fijalkowski wrote:
> > > Currently, if there are multiple xdpsock instances running on a single
> > > interface and in case one of the instances is terminated, the rest of
> > > them are left in an inoperable state due to the fact of unloaded XDP
> > > prog from interface.
> > > 
> > > To address that, step away from setting bpf prog in favour of bpf_link.
> > > This means that refcounting of BPF resources will be done automatically
> > > by bpf_link itself.
> > > 
> > > When setting up BPF resources during xsk socket creation, check whether
> > > bpf_link for a given ifindex already exists via set of calls to
> > > bpf_link_get_next_id -> bpf_link_get_fd_by_id -> bpf_obj_get_info_by_fd
> > > and comparing the ifindexes from bpf_link and xsk socket.
> > > 
> > > If there's no bpf_link yet, create one for a given XDP prog and unload
> > > explicitly existing prog if XDP_FLAGS_UPDATE_IF_NOEXIST is not set.
> > > 
> > > If bpf_link is already at a given ifindex and underlying program is not
> > > AF-XDP one, bail out or update the bpf_link's prog given the presence of
> > > XDP_FLAGS_UPDATE_IF_NOEXIST.
> > > 
> > > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > ---
> > >  tools/lib/bpf/xsk.c | 143 +++++++++++++++++++++++++++++++++++++-------
> > >  1 file changed, 122 insertions(+), 21 deletions(-)
> > 
> > [...]
> > 
> > > +static int xsk_create_bpf_link(struct xsk_socket *xsk)
> > > +{
> > > +	/* bpf_link only accepts XDP_FLAGS_MODES, but xsk->config.xdp_flags
> > > +	 * might have set XDP_FLAGS_UPDATE_IF_NOEXIST
> > > +	 */
> > > +	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
> > > +			    .flags = (xsk->config.xdp_flags & XDP_FLAGS_MODES));
> > > +	struct xsk_ctx *ctx = xsk->ctx;
> > > +	__u32 prog_id;
> > > +	int link_fd;
> > > +	int err;
> > > +
> > > +	/* for !XDP_FLAGS_UPDATE_IF_NOEXIST, unload the program first, if any,
> > > +	 * so that bpf_link can be attached
> > > +	 */
> > > +	if (!(xsk->config.xdp_flags & XDP_FLAGS_UPDATE_IF_NOEXIST)) {
> > > +		err = bpf_get_link_xdp_id(ctx->ifindex, &prog_id, xsk->config.xdp_flags);
> > > +		if (err) {
> > > +			pr_warn("getting XDP prog id failed\n");
> > > +			return err;
> > > +		}
> > > +		if (prog_id) {
> > > +			err = bpf_set_link_xdp_fd(ctx->ifindex, -1, 0);
> > > +			if (err < 0) {
> > > +				pr_warn("detaching XDP prog failed\n");
> > > +				return err;
> > > +			}
> > > +		}
> > >  	}
> > >  
> > > -	ctx->prog_fd = prog_fd;
> > > +	link_fd = bpf_link_create(ctx->prog_fd, xsk->ctx->ifindex, BPF_XDP, &opts);
> > > +	if (link_fd < 0) {
> > > +		pr_warn("bpf_link_create failed: %s\n", strerror(errno));
> > > +		return link_fd;
> > > +	}
> > > +
> > 
> > This can leave the system in a bad state where it unloaded the XDP program
> > above, but then failed to create the link. So we should somehow fix that
> > if possible or at minimum put a note somewhere so users can't claim they
> > shouldn't know this.
> > 
> > Also related, its not good for real systems to let XDP program go missing
> > for some period of time. I didn't check but we should make
> > XDP_FLAGS_UPDATE_IF_NOEXIST the default if its not already.
> 
> Old way of attaching prog is mutual exclusive with bpf_link, right?
> What I'm saying is in order to use one of the two, you need to wipe out
> the current one in favour of the second that you would like to load.

Personally, if I were using above I want the operation to error
if a XDP program is already attached. Then user is forced to remove the
XDP program directly if thats even safe to do.

Reusing UPDATE_IF_NOEXIST flag above seems like an abuse of that flag.
The kernel side does an atomic program swap (or at least it should imo) 
of the programs when it is set. Atomic here is not exactly right though
because driver might reset or do other things, but the point is no
packets are missed without policy. In above some N packets will pass
through the device without policy being applied. This is going to be
subtle and buggy if used in real production systems.

The API needs to do a replace operation not a delete/create and if it
can't do that it needs to error out so the user can figure out what
to do about it.

Do you really need this automatic behavior for something? It clutters
up the API with more flags and I can't see how its useful. If it
errors out just delete the prog using the existing interfaces from the
API user side.

> 
> > 
> > > +	ctx->link_fd = link_fd;
> > >  	return 0;
> > >  }
> > >  
> > 
> > [...]
> > 
> > > +static int xsk_link_lookup(struct xsk_ctx *ctx, __u32 *prog_id)
> > > +{
> > > +	__u32 link_len = sizeof(struct bpf_link_info);
> > > +	struct bpf_link_info link_info;
> > > +	__u32 id = 0;
> > > +	int err;
> > > +	int fd;
> > > +
> > > +	while (true) {
> > > +		err = bpf_link_get_next_id(id, &id);
> > > +		if (err) {
> > > +			if (errno == ENOENT)
> > > +				break;
> > > +			pr_warn("can't get next link: %s\n", strerror(errno));
> > > +			break;
> > > +		}
> > > +
> > > +		fd = bpf_link_get_fd_by_id(id);
> > > +		if (fd < 0) {
> > > +			if (errno == ENOENT)
> > > +				continue;
> > > +			pr_warn("can't get link by id (%u): %s\n", id, strerror(errno));
> > > +			break;
> > > +		}
> > > +
> > > +		memset(&link_info, 0, link_len);
> > > +		err = bpf_obj_get_info_by_fd(fd, &link_info, &link_len);
> > > +		if (err) {
> > > +			pr_warn("can't get link info: %s\n", strerror(errno));
> > > +			close(fd);
> > > +			break;
> > > +		}
> > > +		if (link_info.xdp.ifindex == ctx->ifindex) {
> > > +			ctx->link_fd = fd;
> > > +			*prog_id = link_info.prog_id;
> > > +			break;
> > > +		}
> > > +		close(fd);
> > > +	}
> > > +
> > > +	return errno == ENOENT ? 0 : err;
> > 
> > But, err wont be set in fd < 0 case? I guess we don't want to return 0 if
> > bpf_link_get_fd_by_id fails.
> 
> Good catch!
> 
> > Although I really don't like the construct
> > here that much. I think just `return err` and ensuring err is set correctly
> > would be more clear. At least the fd error case needs to be handled
> > though.
> 
> FWIW, this was inspired by tools/bpf/bpftool/link.c:do_show()

Sure its not my preference, but as long as the bug is resolved I
wont complain. If I hadn't seen the bug I wouldn't have said
anything.

> 
> > 
> > > +}
> > > +


