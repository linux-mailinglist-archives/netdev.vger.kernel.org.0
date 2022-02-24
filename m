Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15BFD4C3442
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 19:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbiBXSBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 13:01:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiBXSBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 13:01:43 -0500
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AAB2556DD;
        Thu, 24 Feb 2022 10:01:12 -0800 (PST)
Received: from relay5-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::225])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id A3CB6CCFC0;
        Thu, 24 Feb 2022 17:41:27 +0000 (UTC)
Received: (Authenticated sender: hadess@hadess.net)
        by mail.gandi.net (Postfix) with ESMTPSA id 8C7601C007E;
        Thu, 24 Feb 2022 17:41:19 +0000 (UTC)
Message-ID: <f965c04f34aabe93fe8ef91bb4d1ce4d24159173.camel@hadess.net>
Subject: Re: [PATCH bpf-next v1 0/6] Introduce eBPF support for HID devices
From:   Bastien Nocera <hadess@hadess.net>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Date:   Thu, 24 Feb 2022 18:41:18 +0100
In-Reply-To: <YhdsgokMMSEQ0Yc8@kroah.com>
References: <20220224110828.2168231-1-benjamin.tissoires@redhat.com>
         <YhdsgokMMSEQ0Yc8@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-02-24 at 12:31 +0100, Greg KH wrote:
> On Thu, Feb 24, 2022 at 12:08:22PM +0100, Benjamin Tissoires wrote:
> > Hi there,
> > 
> > This series introduces support of eBPF for HID devices.
> > 
> > I have several use cases where eBPF could be interesting for those
> > input devices:
> > 
> > - simple fixup of report descriptor:
> > 
> > In the HID tree, we have half of the drivers that are "simple" and
> > that just fix one key or one byte in the report descriptor.
> > Currently, for users of such devices, the process of fixing them
> > is long and painful.
> > With eBPF, we could externalize those fixups in one external repo,
> > ship various CoRe bpf programs and have those programs loaded at
> > boot
> > time without having to install a new kernel (and wait 6 months for
> > the
> > fix to land in the distro kernel)
> 
> Why would a distro update such an external repo faster than they
> update
> the kernel?  Many sane distros update their kernel faster than other
> packages already, how about fixing your distro?  :)
> 
> I'm all for the idea of using ebpf for HID devices, but now we have
> to
> keep track of multiple packages to be in sync here.  Is this making
> things harder overall?

I don't quite understand how taking eBPF quirks for HID devices out of
the kernel tree is different from taking suspend quirks out of the
kernel tree:
https://www.spinics.net/lists/linux-usb/msg204506.html
