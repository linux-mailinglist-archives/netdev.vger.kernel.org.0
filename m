Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 803D0EE5C
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 03:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729881AbfD3BX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 21:23:58 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:60035 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729801AbfD3BX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 21:23:58 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id F069311761;
        Mon, 29 Apr 2019 21:23:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 29 Apr 2019 21:23:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=U802eO
        OelwertqC80gnxnMwTiQXrwdFYQ7LZKBGQt7c=; b=MPXHHQomdU37KyhhAIgL7L
        MnoMJElis48Jw0J2mIvl4w3lmexJr+h1/6YjTNa6pm+rv3eIDrWxlMKJ+tmhFQrb
        dk4OiQ+fQ1PLdl9TKNRcuaLjfNKAoZwbD/WSV6H3KJNp8Sr1cJuH1EMU+FdSNecO
        QvXOk88p2DNbvDHRtJ7oXBr7TyT9JUu9BoOce38aP50qI6OGcC0q9xdAYYDXIC/A
        Bwjk6SQTECIVugZnFV81mzH3gSPzB8O4j7adEZPpeb1UuI9MTd8MhPF4kZ+sWR3n
        d1wLN8zIlzrSsQ+MZCY9PLLcRzBf1XLxrwplRBb4JNrxUqHVA9R57DZZJ5s8Rhxw
        ==
X-ME-Sender: <xms:q6PHXEqeLaDbkntYfC-LIbq6ls_z0bV8tKpBLt8jSNzu1HZxROtZmQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieefgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenog
    etfedtuddqtdduucdludehmdenucfjughrpeffhffvuffkfhggtggujgfofgesthdtredt
    ofervdenucfhrhhomhepfdfvohgsihhnucevrdcujfgrrhguihhnghdfuceothhosghinh
    eskhgvrhhnvghlrdhorhhgqeenucfkphepuddvuddrgeegrddvfedtrddukeeknecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehtohgsihhnsehkvghrnhgvlhdrohhrghenucevlhhush
    htvghrufhiiigvpedt
X-ME-Proxy: <xmx:q6PHXIkpFJ7qPLvOs-BaBB24V5PeCU1mNRKVxDPKFva4CKasNtBPIg>
    <xmx:q6PHXLgGpHtVfF7fQo3XoKjasm-5v97sGje3sXJrh6zG9IHLplJtNA>
    <xmx:q6PHXAeHQw0KihM5_jTQz8AzmYX8Yv2YTwDjMkRiRLwEoSMDxuxp-g>
    <xmx:rKPHXCB9hBfgrOCmlMdWVx7l8WgtHe4tgeu9qFevCQhc8kohC7nP0g>
Received: from localhost (ppp121-44-230-188.bras2.syd2.internode.on.net [121.44.230.188])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3FDFD1037C;
        Mon, 29 Apr 2019 21:23:54 -0400 (EDT)
Date:   Tue, 30 Apr 2019 11:23:15 +1000
From:   "Tobin C. Harding" <tobin@kernel.org>
To:     "Tobin C. Harding" <tobin@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tyler Hicks <tyhicks@canonical.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Wang Hai <wanghai26@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] bridge: Fix error path for kobject_init_and_add()
Message-ID: <20190430012315.GA18524@eros.localdomain>
References: <20190430002817.10785-1-tobin@kernel.org>
 <20190430002817.10785-2-tobin@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430002817.10785-2-tobin@kernel.org>
X-Mailer: Mutt 1.11.4 (2019-03-13)
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 30, 2019 at 10:28:15AM +1000, Tobin C. Harding wrote:

[snip]

The cover letter appears to have gotten lost, I can resend if it makes
things better for you Dave.

FTR this is the contents from it:

Hi Dave,

There are a few places in net/ that are not correctly handling the error
path after calls to kobject_init_and_add().  This set fixes all of these
for net/

This corrects a memory leak if kobject_init() is not followed by a call
to kobject_put()

This set is part of an effort to check/fix all of these mem leaks across
the kernel tree.

For reference this is the behaviour that we are trying to achieve

void fn(void)
{
	int ret;

	ret = kobject_init_and_add(kobj, ktype, NULL, "foo");
	if (ret) {
		kobject_put(kobj);
		return ret;
	}

	ret = some_init_fn();
	if (ret)
		goto err;

	ret = some_other_init_fn();
	if (ret)
		goto other_err;

	kobject_uevent(kobj, KOBJ_ADD);
	return 0;

other_err:
	other_clean_up_fn();
err:
	kobject_del(kobj);
	return ret;
}


 Testing: No testing done, built with config options

CONFIG_NET=y
CONFIG_SYSFS=y
CONFIG_BRIDGE=y


thanks,
Tobin.
