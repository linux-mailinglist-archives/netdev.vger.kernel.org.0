Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C22275C89
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 03:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfGZB2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 21:28:53 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:40342 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfGZB2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 21:28:53 -0400
Received: by mail-qk1-f193.google.com with SMTP id s145so37943328qke.7
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 18:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=1kvoyJ4k0+maq773nHpbwCH4VPrO52C+mUKMi08tPsU=;
        b=pfbLE1V+EcWTEDCNXKkwjcb8UAtPFm2f61SEu4Gzc/rFTpmkFO3sX36JOFxbmaAgAl
         y1wn0DSqZJ5V9XthUQS5a85qSpJ1yevfFOHTiWJxgqvd75P8AzkFo2PIL8OjPzDbbCpG
         xtqZrpFubUWOaFq/y4TdINmsGhbWXhuBcutprLqaDeapFYIdMVJNK7lowZN0T1muzg6Y
         4qjjSki0cSGXe6BkVKCws7I6fBfaafFMAm71vtadD7FXjSv91ude0b49ouxVDKKG2G0/
         6dxWF8McZ86mzApxJ4FPORxVxgbW+SAz0Fozm/t01PfWiBQWeRjisPXph9WXSz+aM+eO
         KS/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=1kvoyJ4k0+maq773nHpbwCH4VPrO52C+mUKMi08tPsU=;
        b=gAvWTUecA1xYcl+6g3Gq58tVM+aZhCBVagk9IGcQYG6zGO8utt20gb0LhTZSmHmdvC
         MFkbTyE5+oqDH4U4kNg6jCm0GV76ub0nI102bgxUClJS4ZWm4auBsFDgMVaEmmbFEERb
         ZBOFEUeJNsA/Fo68PKa6azNtuKF/mDk5cQCuXNNcBSza5Wq7mEOIOpY71lT2/bSzPzuV
         ME5cO02vNBOZi+LsoAtj5z8qzEAdR7bIlSvZqmCzF6i3r/p7kWhN1X5SbSJVqmxNviRM
         n/w5lqPTgsaPWjKFjmE6rKSoRQY/gTlPbOH63n+fmjHYqoBwYuEWE6sndl0/N3JV1AuH
         PkGA==
X-Gm-Message-State: APjAAAVSfxnVbrPU6qN/8Fj931ZPM4a2UVHhIA2MyXJOIiiEruCWdtBV
        BBxCGT+PNHLNYIg0pOyPYqwUYg==
X-Google-Smtp-Source: APXvYqy6YZO4i7Xe+r9UhZ+sYCedQybq0a32JZQwh0EWwwod7A88AFafCdwo7kmtrBQzOBEq1SHgZw==
X-Received: by 2002:ae9:ea09:: with SMTP id f9mr62064340qkg.379.1564104532292;
        Thu, 25 Jul 2019 18:28:52 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id i62sm23773734qke.52.2019.07.25.18.28.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 18:28:52 -0700 (PDT)
Date:   Thu, 25 Jul 2019 18:28:46 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "tanhuazhong@huawei.com" <tanhuazhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "liuyonglong@huawei.com" <liuyonglong@huawei.com>,
        "lipeng321@huawei.com" <lipeng321@huawei.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 07/11] net: hns3: adds debug messages to
 identify eth down cause
Message-ID: <20190725182846.253ae93f@cakuba.netronome.com>
In-Reply-To: <75a02bbe5b3b0f2755cd901a8830d4a3026f9383.camel@mellanox.com>
References: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
        <1563938327-9865-8-git-send-email-tanhuazhong@huawei.com>
        <ffd942e7d7442549a3a6d469709b7f7405928afe.camel@mellanox.com>
        <30483e38-5e4a-0111-f431-4742ceb1aa62@huawei.com>
        <75a02bbe5b3b0f2755cd901a8830d4a3026f9383.camel@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jul 2019 21:59:08 +0000, Saeed Mahameed wrote:
> I couldn't find any rules regarding what to put in kernel log, Maybe
> someone can share ?. but i vaguely remember that the recommendation
> for device drivers is to put nothing, only error/warning messages.

FWIW my understanding is also that only error/warning messages should
be printed. IOW things which should "never happen".

There are some historical exceptions. Probe logs for instance may be
useful, because its not trivial to get to the device if probe fails.

Another one is ethtool flashing, if it takes time we used to print into
logs some message like "please wait patiently". But since Jiri added
the progress messages in devlink that's no longer necessary.

For the messages which are basically printing the name of the function
or name of the function and their args - we have ftrace.

That's my $0.02 :)
