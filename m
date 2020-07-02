Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75689212D56
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 21:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgGBTrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 15:47:01 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40886 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgGBTrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 15:47:00 -0400
Received: by mail-pl1-f195.google.com with SMTP id x11so11697603plo.7;
        Thu, 02 Jul 2020 12:46:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OHFXCZoREfl1GMwKik+5lcCUbnGDc+wlkQ8rGpzOHJY=;
        b=FkPhG6A9U0NVwzmsAT98qHKnNfxcOIO4csmQAuQS+Huj3cN7OUZojfDthIOyqkg+cn
         tQ8sBz63yiKWxLdjBGol4JEk4K0ZRkCdmiZ2MI79q7UGAb0tP2EmpFKIjA4oTmsTXw7H
         AAsfYv8dMIkOtjkF/JwzP1d+q3YxNtULohv7BJNvIpYSVSNkNA+XR/Qew2olbDMA44kT
         eym0Y6ysfnXPbqQO+Qel1NeD3LFrBA4WKNMzuOX+TJnDJmpZJCOkRzqGJVVbKZ9P8I8W
         L1kl3JsKcrs6mosc7N4ImANeT+hfsloxy+o3CNFDohZIzM3rIUq+UbqReWBL0AjTuNoz
         yBHA==
X-Gm-Message-State: AOAM532MQcCPbJ5AwLGsnvWxX7yPB5OzlnQj9L41VQSkrKF73G5VJReq
        xLS6tEb7x0b9kdpx3fy1F0I=
X-Google-Smtp-Source: ABdhPJzZRZZnyTT/LL8zshMzqSe4q6iWh/bqF3eI60b4K/yHnYqIox4lLP9gZCWSkU96CYlxNiNA6Q==
X-Received: by 2002:a17:90a:b38b:: with SMTP id e11mr15548657pjr.120.1593719219005;
        Thu, 02 Jul 2020 12:46:59 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id n18sm10014912pfd.99.2020.07.02.12.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 12:46:57 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 695BF403DC; Thu,  2 Jul 2020 19:46:56 +0000 (UTC)
Date:   Thu, 2 Jul 2020 19:46:56 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        David Howells <dhowells@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, ast@kernel.org,
        axboe@kernel.dk, bfields@fieldses.org,
        bridge@lists.linux-foundation.org, chainsaw@gentoo.org,
        christian.brauner@ubuntu.com, chuck.lever@oracle.com,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        jarkko.sakkinen@linux.intel.com, jmorris@namei.org,
        josh@joshtriplett.org, keescook@chromium.org,
        keyrings@vger.kernel.org, kuba@kernel.org,
        lars.ellenberg@linbit.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, nikolay@cumulusnetworks.com,
        philipp.reisner@linbit.com, ravenexp@gmail.com,
        roopa@cumulusnetworks.com, serge@hallyn.com, slyfox@gentoo.org,
        viro@zeniv.linux.org.uk, yangtiezhu@loongson.cn,
        netdev@vger.kernel.org, markward@linux.ibm.com,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: linux-next: umh: fix processed error when UMH_WAIT_PROC is used
 seems to break linux bridge on s390x (bisected)
Message-ID: <20200702194656.GV4332@42.do-not-panic.com>
References: <4d8fbcea-a892-3453-091f-d57c03f9aa90@de.ibm.com>
 <1263e370-7cee-24d8-b98c-117bf7c90a83@de.ibm.com>
 <20200626025410.GJ4332@42.do-not-panic.com>
 <20200630175704.GO13911@42.do-not-panic.com>
 <b24d8dae-1872-ba2c-acd4-ed46c0781317@de.ibm.com>
 <a6792135-3285-0861-014e-3db85ea251dc@i-love.sakura.ne.jp>
 <20200701135324.GS4332@42.do-not-panic.com>
 <8d714a23-bac4-7631-e5fc-f97c20a46083@i-love.sakura.ne.jp>
 <20200701153859.GT4332@42.do-not-panic.com>
 <e3f3e501-2cb7-b683-4b85-2002b7603244@i-love.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3f3e501-2cb7-b683-4b85-2002b7603244@i-love.sakura.ne.jp>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 01:26:53PM +0900, Tetsuo Handa wrote:
> On 2020/07/02 0:38, Luis Chamberlain wrote:
> > @@ -156,6 +156,18 @@ static void call_usermodehelper_exec_sync(struct subprocess_info *sub_info)
> >  		 */
> >  		if (KWIFEXITED(ret))
> >  			sub_info->retval = KWEXITSTATUS(ret);
> > +		/*
> > +		 * Do we really want to be passing the signal, or do we pass
> > +		 * a single error code for all cases?
> > +		 */
> > +		else if (KWIFSIGNALED(ret))
> > +			sub_info->retval = KWTERMSIG(ret);
> 
> No, this is bad. Caller of usermode helper is unable to distinguish exit(9)
> and e.g. SIGKILL'ed by the OOM-killer.

Right, the question is: do we care?

> Please pass raw exit status value.
> 
> I feel that caller of usermode helper should not use exit status value.
> For example, call_sbin_request_key() is checking
> 
>   test_bit(KEY_FLAG_USER_CONSTRUCT, &key->flags) || key_validate(key) < 0
> 
> condition (if usermode helper was invoked) in order to "ignore any errors from
> userspace if the key was instantiated".

For those not familiar with this code path, or if you cannot decipher
the above, the code path in question was:

static int call_sbin_request_key(struct key *authkey, void *aux)                
{
	...
	/* do it */                                                             
	ret = call_usermodehelper_keys(request_key, argv, envp, keyring,        
				       UMH_WAIT_PROC);
	kdebug("usermode -> 0x%x", ret);
	if (ret >= 0) {
		/* ret is the exit/wait code */
		if (test_bit(KEY_FLAG_USER_CONSTRUCT, &key->flags) ||
		    key_validate(key) < 0)
		    ret = -ENOKEY;
		/* ignore any errors from userspace if the key was      
		 * instantiated */  
		 ret = 0;
	}
	...
}

And the umh patch "umh: fix processed error when UMH_WAIT_PROC is used"
changed this to:

-       if (ret >= 0) {
+       if (ret != 0) {

Prior to the patch negative return values from userspace were still
being captured, and likewise signals, but the error value was not
raw, not the actual value. After the patch, since we check for ret != 0
we still upkeep the sanity check for any error, correct the error value,
but as you noted signals were ignored as I made the wrong assumption
we would ignore them. The umh sub_info->retval is set after my original
patch only if KWIFSIGNALED(ret)), and ignored signals, and so that
would be now capitured with the additional KWIFSIGNALED(ret)) check.

The question still stands:

Do we want to open code all these checks or simply wrap them up in
the umh. If we do the later, as you note exit(9) and a SIGKILL will
be the same to the inspector in the kernel. But do we care?

Do we really want umh callers differntiatin between signals and exit values?

The alternative to making a compromise is using generic wrappers for
things which make sense and letting the callers use those.

  Luis

> > +		/* Same here */
> > +		else if (KWIFSTOPPED((ret)))
> > +			sub_info->retval = KWSTOPSIG(ret);
> > +		/* And are we really sure we want this? */
> > +		else if (KWIFCONTINUED((ret)))
> > +			sub_info->retval = 0;
> >  	}
> >  
> >  	/* Restore default kernel sig handler */
> > 
> 
