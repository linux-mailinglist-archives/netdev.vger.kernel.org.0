Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D74B6C068F
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 00:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjCSXSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 19:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjCSXSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 19:18:45 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D68711165;
        Sun, 19 Mar 2023 16:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679267924; x=1710803924;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=We/kl/1uYRceIicQxDNopU6RQK7meT+1H69xJe7ZTYM=;
  b=QDiNExHHyEHCQfC3E411SKadan/GuP/XJ8zLj123mnSkaSpUZTAqTDaS
   Qtz7hnu2QF0Pmev3CfEh5zpQ7IwWo9RLJbaVE5fTakJwUFynZ6JOc41ur
   laAhKYld34fE7dT7r6y/X63mnRAs5f/9SwnGfPzNhf7/IzOyYF9HpyeKT
   mjSZ6FugRclzfYsI+Lxgp9U3Z/qKw/v8i7S+Dg7joqDX5BtCdu0WhypnI
   QEKvQZf2PPJxcgyH3beaTfFuIynsHTzN0tKd+lFP9CpXMG8EzASkcwZOH
   Y4jJgUz+JKeOqAMWX8ZFRkrtHeBUmGvuHyHGab9QwYugmHBuHFfpfVBAK
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="338569009"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="338569009"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 16:18:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="769980080"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="769980080"
Received: from msbunten-mobl1.amr.corp.intel.com (HELO intel.com) ([10.251.221.102])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 16:18:38 -0700
Date:   Mon, 20 Mar 2023 00:18:13 +0100
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Andrzej Hajda <andrzej.hajda@intel.com>
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, netdev@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Eric Dumazet <edumazet@google.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [Intel-gfx] [PATCH v4 03/10] lib/ref_tracker: add printing to
 memory buffer
Message-ID: <ZBeYNaTUmvAxrzoU@ashyti-mobl2.lan>
References: <20230224-track_gt-v4-0-464e8ab4c9ab@intel.com>
 <20230224-track_gt-v4-3-464e8ab4c9ab@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224-track_gt-v4-3-464e8ab4c9ab@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrzej,

This looks also good, just few questions.

On Mon, Mar 06, 2023 at 05:31:59PM +0100, Andrzej Hajda wrote:
> In case one wants to show stats via debugfs.

shall I say it? I'll say it... you can do better with the log
here. It's not a typo fix :)

> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>

[...]

> +void __ref_tracker_dir_print(struct ref_tracker_dir *dir,
> +			   unsigned int display_limit)
> +{
> +	struct ostream os = {};
> +
> +	__ref_tracker_dir_pr_ostream(dir, display_limit, &os);
> +}
>  EXPORT_SYMBOL(__ref_tracker_dir_print);
>  
>  void ref_tracker_dir_print(struct ref_tracker_dir *dir,
> @@ -114,6 +141,19 @@ void ref_tracker_dir_print(struct ref_tracker_dir *dir,
>  }
>  EXPORT_SYMBOL(ref_tracker_dir_print);
>  
> +int ref_tracker_dir_snprint(struct ref_tracker_dir *dir, char *buf, size_t size)

nit: snprintf is normally referred to its variable parameter
counterpart... I would choose a different name... how about
ref_tracker_dir_fetch_print()?

> +{
> +	struct ostream os = { .buf = buf, .size = size };
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&dir->lock, flags);
> +	__ref_tracker_dir_pr_ostream(dir, 16, &os);
> +	spin_unlock_irqrestore(&dir->lock, flags);

What are you trying to protect with this spinlock? what if
the caller has already locked here? do we need a _locked()
version?

Thanks,
Andi

> +	return os.used;
> +}
> +EXPORT_SYMBOL(ref_tracker_dir_snprint);
> +
>  void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
>  {
>  	struct ref_tracker *tracker, *n;
> 
> -- 
> 2.34.1
