Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 814BB12060A
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 13:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbfLPMnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 07:43:51 -0500
Received: from www62.your-server.de ([213.133.104.62]:38874 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727553AbfLPMnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 07:43:51 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1igpj1-00078Z-Ux; Mon, 16 Dec 2019 13:43:48 +0100
Date:   Mon, 16 Dec 2019 13:43:47 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v4 bpf-next 2/4] libbpf: support libbpf-provided extern
 variables
Message-ID: <20191216124347.GB14887@linux.fritz.box>
References: <20191214014710.3449601-1-andriin@fb.com>
 <20191214014710.3449601-3-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191214014710.3449601-3-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25665/Mon Dec 16 10:52:23 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 05:47:08PM -0800, Andrii Nakryiko wrote:
[...]
> Config file itself is searched in /boot/config-$(uname -r) location with
> fallback to /proc/config.gz, unless config path is specified explicitly
> through bpf_object_open_opts' kernel_config_path option. Both gzipped and
> plain text formats are supported. Libbpf adds explicit dependency on zlib
> because of this, but this shouldn't be a problem, given libelf already depends
> on zlib.

Hm, given this seems to break the build and is not an essential feature,
can't we use the feature detection from tooling infra which you invoke
anyway to compile out bpf_object__read_kernel_config() internals and return
an error there? Build could warn perf-style what won't be available for
the user in that case.

https://patchwork.ozlabs.org/patch/1210213/

Also, does libbpf.pc.template need updating wrt zlib?
