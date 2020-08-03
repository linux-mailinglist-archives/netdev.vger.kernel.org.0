Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F07123B04B
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgHCWjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgHCWjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 18:39:47 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3846FC06174A;
        Mon,  3 Aug 2020 15:39:47 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id g26so36787624qka.3;
        Mon, 03 Aug 2020 15:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qq/OoGqAWgSNxLVy8asfjdh45pV617fREiK/m3ZEZvc=;
        b=QG4ZErxqYyI5iREiUFB1jMDEgaclsLXRd3qwNHgPxJzT+aVI+210+43VgEexTxw6IX
         y74sgnsPzSLxLnp0of6tip9TkJMrGZTLca4BZPcGmV4QSuxBHbQ8KuZD2HKe2n/FwK0d
         yiyFxmA6bZvuGva3RjPOo+IQtbABTApfwxzEa5UTTNDvgkxhj6+iH2Vtw39VhLRndJr+
         vuCoE9wIGSE6oGCunTqahhgLIg/m77qW/XGZQv0yV7j4hrkv207z9NIYQkz6McOWqQzV
         mORR1fIYynddz6vh2HAmDPzlVdz6aEpFFt2K8j589b00+45j5QZ9vWmK2swulkUEe5cO
         f1+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qq/OoGqAWgSNxLVy8asfjdh45pV617fREiK/m3ZEZvc=;
        b=RMZ9XlL9cETbY942TaDmRcPq6CKWYDlgMMOY/lKAtL3BvPeGQwwUk8Tcdfi2vPJRqW
         wd1k9ilhrF+BFT+Ihk0u3iaHEkoSpUEk9fczpHmkVKq6YAtQKYEuecvVz3U7/+v0+yIW
         eFhovPOPQvR9DBD7O5LOcGxOBU0B100y1YFrDF8gemhxiuw3vU2Lcldv4DVqryQLLTcO
         qz5t1B8cNSv4YHaI45RS5RB7/9N9RuUYHIUVUkhOPrdnIcdyUqV9NzbUGhZdLJw3Wmns
         9T9IXzeG/CbyqZDS1UwqWGJEW7YM+rWvO0hao50FcPDUtBB3Ii1P/IfPbAiLmBkCHFl8
         MIXg==
X-Gm-Message-State: AOAM531whge0IvDV1g+NLBkQTOdgm4o1Fg3KbKe10wXdjsnTlKOyJ6Ap
        k5VnMUW4ZlZJigrJ9Z5qrNoMJnA=
X-Google-Smtp-Source: ABdhPJw+GsNsQWRmU7MC/kx5uUzqsIy4eLp6XbvQecrcAmCCTD9dKtBc1b16dqlFsVR4Ob1pT8i7xQ==
X-Received: by 2002:a37:8047:: with SMTP id b68mr17229339qkd.299.1596494386464;
        Mon, 03 Aug 2020 15:39:46 -0700 (PDT)
Received: from PWN (146-115-88-66.s3894.c3-0.sbo-ubr1.sbo.ma.cable.rcncustomer.com. [146.115.88.66])
        by smtp.gmail.com with ESMTPSA id u37sm24292165qtj.47.2020.08.03.15.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 15:39:46 -0700 (PDT)
Date:   Mon, 3 Aug 2020 18:39:43 -0400
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     pshelar@ovn.org, kuba@kernel.org, dan.carpenter@oracle.com,
        arnd@arndb.de, gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net] openvswitch: Prevent
 kernel-infoleak in ovs_ct_put_key()
Message-ID: <20200803223943.GA279188@PWN>
References: <20200731044838.213975-1-yepeilin.cs@gmail.com>
 <20200803.151038.440269686968773655.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803.151038.440269686968773655.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 03:10:38PM -0700, David Miller wrote:
> From: Peilin Ye <yepeilin.cs@gmail.com>
> Date: Fri, 31 Jul 2020 00:48:38 -0400
> 
> > ovs_ct_put_key() is potentially copying uninitialized kernel stack memory
> > into socket buffers, since the compiler may leave a 3-byte hole at the end
> > of `struct ovs_key_ct_tuple_ipv4` and `struct ovs_key_ct_tuple_ipv6`. Fix
> > it by initializing `orig` with memset().
> > 
> > Cc: stable@vger.kernel.org
> 
> Please don't CC: stable for networking fixes.

Sorry, I didn't know about that.

> > Fixes: 9dd7f8907c37 ("openvswitch: Add original direction conntrack tuple to sw_flow_key.")
> > Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> 
> Applied and queued up for -stable, thank you.

Thank you for reviewing the patch!

Peilin Ye
