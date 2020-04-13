Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1651A6C2E
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 20:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387764AbgDMSqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 14:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387752AbgDMSqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 14:46:37 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAEAC0A3BDC;
        Mon, 13 Apr 2020 11:46:36 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id t3so6720838qkg.1;
        Mon, 13 Apr 2020 11:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B4/iE8GVKGojMY11LgRwzzoKBbfHwK52clilGbP458E=;
        b=pTO/WjNpVdwOK4PnWxhCMTYXfGmfB8muGhdDm+Ce71BPZe+MW8p8yeTQiayHizwzwT
         dgEF6aOD4BwoyF68f9gOMrQ+2Hz25jt4W30K57oMp+1GSK8UHczVG+IbXzIV//kzAGXX
         b10k2DpkBpg6axGglNnH/DfoXuIXAIXE5R4YBbMg4PXJ6fw+saDmIvuH5OCjZ+6rkQxi
         sksjChxy7JVXLzBwTOGmRrxaWIStYn0sOXZ/9bzAaR9VT2BNqd2x7Z2Iniqj562q7N27
         HBiyhXviyY2M99/y9yU9vXJiTNZyQyP3vc+Ec1KeBa/nFjM8yKPUEy/MXjFtS7iRBAhU
         zDxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=B4/iE8GVKGojMY11LgRwzzoKBbfHwK52clilGbP458E=;
        b=oJhg8WOoeU92k7y35GONy5QpXbFhzaePUNZPxjoNDG6IEvU3xkd000pf5cPImWBni8
         UdtytLlxalwBPEuuChA28+8HV/Eo/AKJZwmiB6NZ7FmLx7sFaUw8rxgIKyl4M0yBgwxF
         1AUCBSpYBt4L2tsJA8uKejztf34YD7Fq6Ir4vEpFQ4LACeMq0JThVv4SQXK3iPalDFpH
         24p9mQdfUcHDr/HqKR8dE3cMmwDZDywWWteOCwbrR7g3nXJpKhBNpnzwy+A+XpV56rXo
         hIDR/s4mY4cQtZbkqlZOHIjRSaBHlqdHQOKxA7KUP9e0lyvzPyA15RBCMLHQgZN6B3IJ
         00Sg==
X-Gm-Message-State: AGi0PuZU5bLUvzKsEOuyzILA38X7FuboHrDBAQrup777N9x5IoeoDSOP
        5y4lfEQyzdhr2rC4JQ9iXv4=
X-Google-Smtp-Source: APiQypLKepMwA9LtxBn20WaoLlrzuTVCfwR/X0X8krJlPBMLp0nDMiksr03kHgbiZ5zOubCeR4gVhA==
X-Received: by 2002:a37:414f:: with SMTP id o76mr6343409qka.462.1586803595747;
        Mon, 13 Apr 2020 11:46:35 -0700 (PDT)
Received: from localhost ([199.96.181.106])
        by smtp.gmail.com with ESMTPSA id j2sm9039587qth.57.2020.04.13.11.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 11:46:35 -0700 (PDT)
Date:   Mon, 13 Apr 2020 14:46:34 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Serge Hallyn <serge@hallyn.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saravana Kannan <saravanak@google.com>,
        Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        David Rheinsberg <david.rheinsberg@gmail.com>,
        Tom Gundersen <teg@jklm.no>,
        Christian Kellner <ckellner@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 4/8] kernfs: handle multiple namespace tags
Message-ID: <20200413184634.GF60335@mtj.duckdns.org>
References: <20200408152151.5780-1-christian.brauner@ubuntu.com>
 <20200408152151.5780-5-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408152151.5780-5-christian.brauner@ubuntu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 08, 2020 at 05:21:47PM +0200, Christian Brauner wrote:
> Since [1] kernfs supports namespace tags. This feature is essential to
> enable sysfs to present different views of on various parts depending on
> the namespace tag. For example, the /sys/class/net/ directory will only
> show network devices that belong to the network namespace that sysfs was
> mounted in. This is achieved by stashing a reference to the network
> namespace of the task mounting sysfs in the super block. And when a
> lookup operation is performed on e.g. /sys/class/net/ kernfs will
> compare the network namespace tag of the kernfs_node associated with the
> device and kobject of the network device to the network namespace of the
> network device. This ensures that only network devices owned by the
> network namespace sysfs was mounted in are shown, a feature which is
> essential to containers.
> For loopfs to show correct permissions in sysfs just as with network
> devices we need to be able to tag kernfs_super_info with additional
> namespaces. This extension was even already mentioned in a comment to
> struct kernfs_super_info:
>   /*
>    * Each sb is associated with one namespace tag, currently the
>    * network namespace of the task which mounted this kernfs
>    * instance.  If multiple tags become necessary, make the following
>    * an array and compare kernfs_node tag against every entry.
>    */
> This patch extends the kernfs_super_info and kernfs_fs_context ns
> pointers to fixed-size arrays of namespace tags. The size is taken from
> the namespaces currently supported by kobjects, i.e. we don't extend it
> to cover all namespace but only the ones kernfs needs to support.
> In addition, the kernfs_node struct gains an additional member that
> indicates the type of namespace this kernfs_node was tagged with. This
> allows us to simply retrieve the correct namespace tag from the
> kernfs_fs_context and kernfs_super_info ns array with a simple indexing
> operation. This has the advantage that we can just keep passing down the
> correct namespace instead of passing down the array.
> 
> [1]: 608b4b9548de ("netns: Teach network device kobjects which namespace they are in.")
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
