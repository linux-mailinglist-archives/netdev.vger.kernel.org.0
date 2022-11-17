Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C75062D432
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 08:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239372AbiKQHgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 02:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239395AbiKQHgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 02:36:25 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33622716C4
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 23:36:24 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id t25-20020a1c7719000000b003cfa34ea516so3996371wmi.1
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 23:36:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OFcbW7NW5DDCKre2yJpKCmdI+15tLoMafsU/GK41iCg=;
        b=oHr+FaZgYEv23JaNnCjuR1kU450HEhhtx+qI1mgdxExYBkKbCAFN3d1CeBhwdbDKUU
         MOH6YGskf/ogOfAonyZVA0CDqr8iY/90NBYrE95Vw4vCNbzdzd7CuPwda4qHgH1cm3ug
         QZResj+c/Wu+euO8OFAvzJwwnCheNifFO76JHRV3uMr511m6Kkmiqj5vsapWDumyXgTZ
         y3G5HbcB/spzcaU5ha6ukgyKXXQZ/Qr8qhkLlcoFZfk8oTlJ8np345efK99fqjoeLRpY
         3V8DXaF0xKaBd/y6dir6d5OUeiNQ6vPIXIp3WV6UTyDupam/Xz0Y8/B1DP7ekpxw0Isy
         VhmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OFcbW7NW5DDCKre2yJpKCmdI+15tLoMafsU/GK41iCg=;
        b=oEE6ld2PNxaemPqhrk3J7g66s/ilAtG9frWXUHM977Bh67ECKGz6+y4tCqnq5kuNlC
         JooLXvArlK3X4qRTjIVPF0bb7o2ZVUQWGP9R/1BCjkdM5t6TU27qNSGJV7VFB39M00Uq
         paXDHGgYgoU5DtIflxUNd6PlGmVq08wFw4SBls3PIHgqiH/ZVZ8cM1PL2cf0Mfe2Hy1n
         E/dz5Bz4JQ9Y97riQOvu+ZHBN6NDgbLO2h4Vc1cJ9RJeYDajPuSQ9bekSYm7/QqTmCF6
         HPKuq7kVtja2npPeXdDR+/ikcc0uPRTbpIcb+RUsr42t2brsIc0c077VOJroisq3hC7X
         fGAA==
X-Gm-Message-State: ANoB5pkM2hBOP4jaBMytqbLPPFB50Cmp4cqoxDYCzbG1WuobQKvBZZz7
        cbql7o8VWr5NZr/C83YczIo=
X-Google-Smtp-Source: AA0mqf43jItg7WqELp/x05EyDow+9qYAHfTbuUbJ28ducG6oUYJtvv6zNgytfK+w7qNpDpTDUYISOA==
X-Received: by 2002:a05:600c:3ba8:b0:3cf:59c9:4a4e with SMTP id n40-20020a05600c3ba800b003cf59c94a4emr4345877wms.17.1668670582659;
        Wed, 16 Nov 2022 23:36:22 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id n38-20020a05600c182600b003c6deb5c1edsm238259wmp.45.2022.11.16.23.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 23:36:22 -0800 (PST)
Date:   Thu, 17 Nov 2022 10:36:19 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     oe-kbuild@lists.linux.dev, Eric Dumazet <edumazet@google.com>
Cc:     lkp@intel.com, oe-kbuild-all@lists.linux.dev,
        netdev@vger.kernel.org
Subject: [net-next:master 25/27] net/core/dev.c:6409 napi_disable() error:
 uninitialized symbol 'new'.
Message-ID: <202211171520.UF5VyYSH-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   d82303df06481235fe7cbaf605075e0c2c87e99b
commit: 4ffa1d1c6842a97e84cfbe56bfcf70edb23608e2 [25/27] net: adopt try_cmpxchg() in napi_{enable|disable}()
config: i386-randconfig-m021
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <error27@gmail.com>

New smatch warnings:
net/core/dev.c:6409 napi_disable() error: uninitialized symbol 'new'.

Old smatch warnings:
net/core/dev.c:10356 netdev_run_todo() warn: passing freed memory 'dev'

vim +/new +6409 net/core/dev.c

3b47d30396bae4 Eric Dumazet   2014-11-06  6393  void napi_disable(struct napi_struct *n)
3b47d30396bae4 Eric Dumazet   2014-11-06  6394  {
719c571970109b Jakub Kicinski 2021-09-24  6395  	unsigned long val, new;
719c571970109b Jakub Kicinski 2021-09-24  6396  
3b47d30396bae4 Eric Dumazet   2014-11-06  6397  	might_sleep();
3b47d30396bae4 Eric Dumazet   2014-11-06  6398  	set_bit(NAPI_STATE_DISABLE, &n->state);
3b47d30396bae4 Eric Dumazet   2014-11-06  6399  
719c571970109b Jakub Kicinski 2021-09-24  6400  	val = READ_ONCE(n->state);
4ffa1d1c6842a9 Eric Dumazet   2022-11-15  6401  	do {
719c571970109b Jakub Kicinski 2021-09-24  6402  		if (val & (NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC)) {
719c571970109b Jakub Kicinski 2021-09-24  6403  			usleep_range(20, 200);
719c571970109b Jakub Kicinski 2021-09-24  6404  			continue;

"new" not initialized for first iteration through the loop.

719c571970109b Jakub Kicinski 2021-09-24  6405  		}
719c571970109b Jakub Kicinski 2021-09-24  6406  
719c571970109b Jakub Kicinski 2021-09-24  6407  		new = val | NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC;
719c571970109b Jakub Kicinski 2021-09-24  6408  		new &= ~(NAPIF_STATE_THREADED | NAPIF_STATE_PREFER_BUSY_POLL);
4ffa1d1c6842a9 Eric Dumazet   2022-11-15 @6409  	} while (!try_cmpxchg(&n->state, &val, new));
                                                                                               ^^^

3b47d30396bae4 Eric Dumazet   2014-11-06  6410  
3b47d30396bae4 Eric Dumazet   2014-11-06  6411  	hrtimer_cancel(&n->timer);
3b47d30396bae4 Eric Dumazet   2014-11-06  6412  
3b47d30396bae4 Eric Dumazet   2014-11-06  6413  	clear_bit(NAPI_STATE_DISABLE, &n->state);
3b47d30396bae4 Eric Dumazet   2014-11-06  6414  }

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

