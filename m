Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117284CDCC8
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 19:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241767AbiCDSkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 13:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbiCDSkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 13:40:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30D94EA0D;
        Fri,  4 Mar 2022 10:40:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 644BFB82B63;
        Fri,  4 Mar 2022 18:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A5AC340E9;
        Fri,  4 Mar 2022 18:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646419201;
        bh=CZIhUQHqu5oaQKeIUzZql0M06GBYeqKM/sTvIzQL7yE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WojpUJC1S7fQwY/4kKnhgEQQW16fc2kdjB9QFl5g58vA5vXpCx+niW3A7M65cbChW
         yE+hG1GICR1iCdtgPtVTiOnEn7SOgVT3wxPtEfNOBnq0XrQfXs9jZYx1nMsEcr0rmE
         WVsfkWK2juyCkD/JI/lcM6BJsdNtb0VGekSrwfqw=
Date:   Fri, 4 Mar 2022 19:39:52 +0100
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
Subject: Re: [PATCH bpf-next v2 13/28] HID: bpf: implement
 hid_bpf_get|set_data
Message-ID: <YiJc+Gu93NLA8kvr@kroah.com>
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
 <20220304172852.274126-14-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304172852.274126-14-benjamin.tissoires@redhat.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_RED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 06:28:37PM +0100, Benjamin Tissoires wrote:
> We have 2 cases of usage here:
> - either n <= 32: we are addressing individual bits at the given offset
> 
> - either n > 32: we are using a memcpy to transmit the data to the caller,
>   meaning that we need to be byte-aligned.

That is crazy.  Can you split this into a bits/bytes function set to
have 4 of them?  You are using each function in two totally different
ways.

thanks,

greg k-h
