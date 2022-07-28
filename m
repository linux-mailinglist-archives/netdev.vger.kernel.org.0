Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1AB7584299
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 17:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiG1PKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 11:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiG1PKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 11:10:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786D6F02;
        Thu, 28 Jul 2022 08:10:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EABAB8247E;
        Thu, 28 Jul 2022 15:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504D5C433D6;
        Thu, 28 Jul 2022 15:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659021008;
        bh=l0bE4KitRMr4TS8LjYN+oqMjkbk1ANtyRmk5pvk0GEY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cANvheKnSwNeSdnN6ZjkQoN0h+IrxefvySkStaNLzzF1OrvK75HhIN6ObMIHzy7oW
         Hg+8NSfUfgqiVrbY8zBL+VelIhGsB1a0nq/D8O4kvqBHAmeAIndgq/sjYtha6l3et6
         7nOnhN9KSxtwk+76yU4VKLoarUxSon3uFS4WB3Hc=
Date:   Thu, 28 Jul 2022 17:10:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH bpf-next v7 15/24] HID: bpf: allocate data memory for
 device_event BPF programs
Message-ID: <YuKmznAzAi2w9a/3@kroah.com>
References: <20220721153625.1282007-1-benjamin.tissoires@redhat.com>
 <20220721153625.1282007-16-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721153625.1282007-16-benjamin.tissoires@redhat.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 05:36:16PM +0200, Benjamin Tissoires wrote:
> We need to also be able to change the size of the report.
> Reducing it is easy, because we already have the incoming buffer that is
> big enough, but extending it is harder.
> 
> Pre-allocate a buffer that is big enough to handle all reports of the
> device, and use that as the primary buffer for BPF programs.
> To be able to change the size of the buffer, we change the device_event
> API and request it to return the size of the buffer.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
