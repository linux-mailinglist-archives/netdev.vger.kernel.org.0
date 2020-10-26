Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A37C2988D8
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 09:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1772347AbgJZI43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 04:56:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38141 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1772342AbgJZI40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 04:56:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603702585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=20CfvC0VxRiGqy0SH5xo/sYibgiWw3oxgj9p2QBZAiM=;
        b=Z9l8iezwgGZYeSXGV6YRK9sUS/Pqse6F6V5nrQU7ou60nNdPDgwKmfx+mUnzLN2zZTaz5x
        t0F7vwlP/YPD5I64W8hVlw9OShSJR/jlsVvH/O06UL49gZa+rWt+raSQUBedh+DyM+LhSC
        bN+1qEuj/mG9EzQPOklXvIO7MSgiRHk=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-aJ8lrXbpP-i-oKN1iVXwkg-1; Mon, 26 Oct 2020 04:56:23 -0400
X-MC-Unique: aJ8lrXbpP-i-oKN1iVXwkg-1
Received: by mail-pf1-f200.google.com with SMTP id a27so5218784pfl.17
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 01:56:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=20CfvC0VxRiGqy0SH5xo/sYibgiWw3oxgj9p2QBZAiM=;
        b=ubw1bnG6CAeDTPvRAUuVoG9f2HN61rXrPsCxxiFCJFQsduH6bzsLUi7GmGhhRPaSfY
         pE4NMwN6SBPPleevYYvg474SJCLLVqKYsr4TAQC2JclTCWLFUnEmSuBBJLq+PASfSRrz
         TuodSUZjiCUcIl5U69gruSaYwA3OfJOzxumJJEoHiexffAXl9ZkOSBThUsH8f61hLsJp
         ist26L96uvmIJNOCOgaV5xBhsOTVe5sexFEuT2rcKeZCErziD669+fQqKr5TkBbwqr7E
         N/59wW0rv5Y5azqB/BYdi8A83ggrRP/FKtrumxf0uvpMxCpIiSgPasWVL22Asso9v3+w
         wgJw==
X-Gm-Message-State: AOAM532siGzH11QOhiEiR28CisMw2fLt4tQ19QOD32qB2sm2rLWvr79B
        j+nrxV9BbHmvZ+W4TeTUAmH+Ypj7CGadZax6cdzndMB9+W9KAWM9BMgILf/CDdd0OdrXZX7QItO
        W75Ur9p0uXsS66kw=
X-Received: by 2002:a17:90a:740a:: with SMTP id a10mr15592998pjg.32.1603702582723;
        Mon, 26 Oct 2020 01:56:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKFTxGXGAON0ykGUN0CPQzsxogZ8ps0FJA64V5P3Gilprubpn5PKDTE5m+xi4IeCrUnp4/eA==
X-Received: by 2002:a17:90a:740a:: with SMTP id a10mr15592971pjg.32.1603702582510;
        Mon, 26 Oct 2020 01:56:22 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f4sm11864366pjs.8.2020.10.26.01.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 01:56:21 -0700 (PDT)
Date:   Mon, 26 Oct 2020 16:56:10 +0800
From:   Hangbin Liu <haliu@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH iproute2-next 3/5] lib: add libbpf support
Message-ID: <20201026085610.GE2408@dhcp-12-153.nay.redhat.com>
References: <20201023033855.3894509-1-haliu@redhat.com>
 <20201023033855.3894509-4-haliu@redhat.com>
 <29c13bd0-d2f6-b914-775c-2d90270f86d4@gmail.com>
 <87eelm5ofg.fsf@toke.dk>
 <91aed9d1-d550-cf6c-d8bb-e6737d0740e0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <91aed9d1-d550-cf6c-d8bb-e6737d0740e0@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi David,

On Sun, Oct 25, 2020 at 04:12:34PM -0600, David Ahern wrote:
> On 10/25/20 9:13 AM, Toke Høiland-Jørgensen wrote:
> > David Ahern <dsahern@gmail.com> writes:
> > 
> >> On 10/22/20 9:38 PM, Hangbin Liu wrote:
> >>> Note: ip/ipvrf.c is not convert to use libbpf as it only encodes a few
> >>> instructions and load directly.
> >>
> >> for completeness, libbpf should be able to load a program from a buffer
> >> as well.
> > 
> > It can, but the particular use in ipvrf is just loading half a dozen
> > instructions defined inline in C - there's no object files, BTF or
> > anything. So why bother with going through libbpf in this case? The
> > actual attachment is using the existing code anyway...
> > 
> 
> actually, it already does: bpf_load_program

Thanks for this info. Do you want to convert ipvrf.c to:

@@ -256,8 +262,13 @@ static int prog_load(int idx)
 		BPF_EXIT_INSN(),
 	};
 
+#ifdef HAVE_LIBBPF
+	return bpf_load_program(BPF_PROG_TYPE_CGROUP_SOCK, prog, sizeof(prog),
+				"GPL", 0, bpf_log_buf, sizeof(bpf_log_buf));
+#else
 	return bpf_prog_load_buf(BPF_PROG_TYPE_CGROUP_SOCK, prog, sizeof(prog),
 			         "GPL", bpf_log_buf, sizeof(bpf_log_buf));
+#endif
 }
 
 static int vrf_configure_cgroup(const char *path, int ifindex)
@@ -288,7 +299,11 @@ static int vrf_configure_cgroup(const char *path, int ifindex)
 		goto out;
 	}
 
+#ifdef HAVE_LIBBPF
+	if (bpf_prog_attach(prog_fd, cg_fd, BPF_CGROUP_INET_SOCK_CREATE, 0)) {
+#else
 	if (bpf_prog_attach_fd(prog_fd, cg_fd, BPF_CGROUP_INET_SOCK_CREATE)) {
+#endif
 		fprintf(stderr, "Failed to attach prog to cgroup: '%s'\n",
 			strerror(errno));
 		goto out;

Thanks
Hangbin

