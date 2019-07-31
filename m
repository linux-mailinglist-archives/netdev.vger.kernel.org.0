Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC7B17BE00
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 12:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfGaKIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 06:08:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47888 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbfGaKIL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 06:08:11 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 703488553F;
        Wed, 31 Jul 2019 10:08:11 +0000 (UTC)
Received: from carbon (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B0D360852;
        Wed, 31 Jul 2019 10:08:06 +0000 (UTC)
Date:   Wed, 31 Jul 2019 12:08:05 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     brouer@redhat.com, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH 1/2] tools: bpftool: add net load command to load XDP on
 interface
Message-ID: <20190731120805.1091d5c9@carbon>
In-Reply-To: <20190730184821.10833-2-danieltimlee@gmail.com>
References: <20190730184821.10833-1-danieltimlee@gmail.com>
        <20190730184821.10833-2-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 31 Jul 2019 10:08:11 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Jul 2019 03:48:20 +0900
"Daniel T. Lee" <danieltimlee@gmail.com> wrote:

> By this commit, using `bpftool net load`, user can load XDP prog on
> interface. New type of enum 'net_load_type' has been made, as stated at
> cover-letter, the meaning of 'load' is, prog will be loaded on interface.

Why the keyword "load" ?
Why not "attach" (and "detach")?

For BPF there is a clear distinction between the "load" and "attach"
steps.  I know this is under subcommand "net", but to follow the
conversion of other subcommands e.g. "prog" there are both "load" and
"attach" commands.


> BPF prog will be loaded through libbpf 'bpf_set_link_xdp_fd'.

Again this is a "set" operation, not a "load" operation.

> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

[...]
>  static int do_show(int argc, char **argv)
>  {
>  	struct bpf_attach_info attach_info = {};
> @@ -305,13 +405,17 @@ static int do_help(int argc, char **argv)
>  
>  	fprintf(stderr,
>  		"Usage: %s %s { show | list } [dev <devname>]\n"
> +		"       %s %s load PROG LOAD_TYPE <devname>\n"

The "PROG" here does it correspond to the 'bpftool prog' syntax?:

 PROG := { id PROG_ID | pinned FILE | tag PROG_TAG }

>  		"       %s %s help\n"
> +		"\n"
> +		"       " HELP_SPEC_PROGRAM "\n"
> +		"       LOAD_TYPE := { xdp | xdpgeneric | xdpdrv | xdpoffload }\n"
>  		"Note: Only xdp and tc attachments are supported now.\n"
>  		"      For progs attached to cgroups, use \"bpftool cgroup\"\n"
>  		"      to dump program attachments. For program types\n"
>  		"      sk_{filter,skb,msg,reuseport} and lwt/seg6, please\n"
>  		"      consult iproute2.\n",


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
