Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFB44CDCA3
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 19:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241760AbiCDSf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 13:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbiCDSfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 13:35:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9BB1B3A72;
        Fri,  4 Mar 2022 10:35:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FD97B82B33;
        Fri,  4 Mar 2022 18:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8ACC340E9;
        Fri,  4 Mar 2022 18:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646418904;
        bh=VspvfKvvftytlJT5f16IAdHG7Sa6FqooxzJfMWhUAYI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JH1GBY8KoPTo5zS/7jY5BUEh5CcIH0vMZ2MKdA2NkhKE1o0U/4bHuKH1kWDUOaA3r
         q6u8qFlbYTlpDU2fo3+XXQKZlwHIwVP/kNTFAvjCnqgwUXzbCVI10OBWfUnUCuWQwf
         A6bHhUBGiIrldc0QbPY8x+CrwiE9ebegxd69jQ/k=
Date:   Fri, 4 Mar 2022 19:34:56 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
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
Subject: Re: [PATCH bpf-next v2 10/28] selftests/bpf: add report descriptor
 fixup tests
Message-ID: <YiJb0Lsee3esiFy4@kroah.com>
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
 <20220304172852.274126-11-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304172852.274126-11-benjamin.tissoires@redhat.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_RED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 06:28:34PM +0100, Benjamin Tissoires wrote:
> Simple report descriptor override in HID: replace part of the report
> descriptor from a static definition in the bpf kernel program.
> 
> Note that this test should be run last because we disconnect/reconnect
> the device, meaning that it changes the overall uhid device.

You might want to add that in a comment right before:

> @@ -329,6 +395,9 @@ void serial_test_hid_bpf(void)
>  	err = test_hid_raw_event(hid_skel, uhid_fd, sysfs_fd);
>  	ASSERT_OK(err, "hid");
>  
> +	err = test_rdesc_fixup(hid_skel, uhid_fd, sysfs_fd);
> +	ASSERT_OK(err, "hid_rdesc_fixup");

There, so that you don't add another test after this later on in 5
years.

Anyway, just a nit:

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
