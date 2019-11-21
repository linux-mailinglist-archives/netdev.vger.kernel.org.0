Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5280104E2C
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 09:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbfKUIj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 03:39:29 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3714 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfKUIj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 03:39:28 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dd64d3b0000>; Thu, 21 Nov 2019 00:39:23 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 21 Nov 2019 00:39:27 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 21 Nov 2019 00:39:27 -0800
Received: from [10.2.169.101] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 21 Nov
 2019 08:39:26 +0000
Subject: Re: [PATCH v7 06/24] goldish_pipe: rename local pin_user_pages()
 routine
To:     Christoph Hellwig <hch@infradead.org>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, <bpf@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
References: <20191121071354.456618-1-jhubbard@nvidia.com>
 <20191121071354.456618-7-jhubbard@nvidia.com>
 <20191121080831.GD30991@infradead.org>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <ca78671b-4ce6-05f6-01ae-2d0b79810956@nvidia.com>
Date:   Thu, 21 Nov 2019 00:36:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191121080831.GD30991@infradead.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574325563; bh=IjAmlqSQ50mtR26fvAkI3XcKPC6M4/uU5ND8d4hZ9sk=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=GJ7FLsOPPSpCRACz8ISfrqvd6vXd1a++lXIZbI549CHSZBewXeafsw0KWGYiFyEQk
         AjT450/QZ9YlyRa61hUCDn7RU+Oc8PL9dGnNibH+8bRoPgHv7Hz9Gs/GqPZ/w8xTGJ
         UkFV63r7a5GxMQEBp17Bq1eVxtVmga7DN1IyZXoIl4Zpf7mXrb2vg8FAmf6Cu6rI6y
         ak3fa9vBD/bNjvt15SEsNGr7fQAZcfHOLD1JwudJ1lf0vZTrImmtVmX/zYP64flAJZ
         dWmb9NYUnY/5E0dPUahr3TtiO6k8/kvovVBf9GgTEDfKn0Ljy0UH2gpWXn36gxJ8fZ
         1KUFjQ7Bhke0w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/19 12:08 AM, Christoph Hellwig wrote:
> On Wed, Nov 20, 2019 at 11:13:36PM -0800, John Hubbard wrote:
>> +static int pin_goldfish_pages(unsigned long first_page,
>> +			      unsigned long last_page,
>> +			      unsigned int last_page_size,
>> +			      int is_write,
>> +			      struct page *pages[MAX_BUFFERS_PER_COMMAND],
>> +			      unsigned int *iter_last_page_size)
> 
> Why not goldfish_pin_pages?  Normally we put the module / subsystem
> in front.

Heh, is that how it's supposed to go?  Sure, I'll change it. :)

> 
> Also can we get this queued up for 5.5 to get some trivial changes
> out of the way?
> 

Is that a question to Andrew, or a request for me to send this as a
separate patch email (or both)?


thanks,
-- 
John Hubbard
NVIDIA
