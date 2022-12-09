Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C84647F0D
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 09:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiLIINC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 03:13:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiLIIMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 03:12:54 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2435813F5A;
        Fri,  9 Dec 2022 00:12:50 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id n7so2978185wms.3;
        Fri, 09 Dec 2022 00:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WF2y6U7mb0QNFcy6hcoIbOM2S9xAAvAEUxLp1c0uXWo=;
        b=Q2ObPXpZraitcxiOy6MXLC7KJ+VuKdnIZSAxvYgoX3WFiRh99uoJFIBzNgsafs05q8
         1wYoJ9iRnZBXqT5OCvl06LijGgVyEdNsqm+x31+lK2oqkJWGhcij0t3fllKITtKlmSxm
         PHQOEf9azbtTjTGLINp8YnX94MI8r/x5BPIp8qwJ/Cly1vp2eWQ5MXtAgFOJgD/XsI8+
         rdNzkPbTxF92CNCiiHu1+PwPzxeko370cdbt9pUD+HDCr+bnquOCbYvVwDNEHQd6XLQH
         yJinkA3HEF9SCZba7GC2ivX4s8mrFBYLMvzHosh07JnPgnPA87xB2Fk4SyH1lgW2dgsF
         9btQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WF2y6U7mb0QNFcy6hcoIbOM2S9xAAvAEUxLp1c0uXWo=;
        b=d62TVzsso+Z4oQGPjBzR4XYI/XgcPin1tatlVdCXE+bLXj4/LKct6j3yoRfW5dYG78
         8+Ni4l6uqMW3q5npdbbBC9p/VU5ECMk41pkl1wwDSS3xqOWyVLEiuTQcEEDmzwR+tF2d
         QQ56z0nS+wfecWQiwipfQdMN6xZFlQbWXUHvqOlszK745pxzqY8Eiwir4WgPBCZ0jsyh
         ckD+vh77hLaXdUtO86iaGCBKjLPvwSA4ck19CGp+qb0FqkIyqXmC9tlmhiPKDgY82TwS
         bwbGTXDOxEy96QE5Iv4PpegLMvfXbNNkFl6y0FBSLuUQbEJg/qPdodQBPGbWIMIfxWRk
         U3yw==
X-Gm-Message-State: ANoB5pkjY1eZ6ogZfRHxHCXyM+/0sTgPcZm3mPhS5bCJlMACsixsNPWU
        /1zWwwjOfXWEAeNyokaiNxo=
X-Google-Smtp-Source: AA0mqf7Fi1S01ScAg1F9FqUIW8wpbcedQFtTSGwarK/nSwpeyFGHg6z6Br9SFQwCnOXlf9ktjL/DTQ==
X-Received: by 2002:a05:600c:4f96:b0:3d1:c895:930c with SMTP id n22-20020a05600c4f9600b003d1c895930cmr3919893wmq.35.1670573569238;
        Fri, 09 Dec 2022 00:12:49 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id q128-20020a1c4386000000b003c71358a42dsm9421265wma.18.2022.12.09.00.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 00:12:48 -0800 (PST)
Date:   Fri, 9 Dec 2022 11:12:44 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     oe-kbuild@lists.linux.dev, Jaewan Kim <jaewan@google.com>,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lkp@intel.com, oe-kbuild-all@lists.linux.dev,
        kernel-team@android.com, adelva@google.com,
        Jaewan Kim <jaewan@google.com>
Subject: Re: [PATCH 2/2] mac80211_hwsim: handle RTT requests with virtio
Message-ID: <202212090854.IADKAyXy-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205171851.2811239-2-jaewan@google.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jaewan,

https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jaewan-Kim/mac80211_hwsim-add-PMSR-capability-support/20221206-012111
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git main
patch link:    https://lore.kernel.org/r/20221205171851.2811239-2-jaewan%40google.com
patch subject: [PATCH 2/2] mac80211_hwsim: handle RTT requests with virtio
config: ia64-randconfig-m041-20221204
compiler: ia64-linux-gcc (GCC) 12.1.0

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <error27@gmail.com>

smatch warnings:
drivers/net/wireless/mac80211_hwsim.c:3239 mac80211_hwsim_send_pmsr_ftm_request_peer() warn: variable dereferenced before check 'request' (see line 3235)
drivers/net/wireless/mac80211_hwsim.c:3504 mac80211_hwsim_abort_pmsr() warn: inconsistent returns '&data->mutex'.
drivers/net/wireless/mac80211_hwsim.c:3800 hwsim_pmsr_report_nl() error: uninitialized symbol 'err'.

vim +/request +3239 drivers/net/wireless/mac80211_hwsim.c

8027b096313ab2 Jaewan Kim    2022-12-06  3230  static int mac80211_hwsim_send_pmsr_ftm_request_peer(struct sk_buff *msg,
8027b096313ab2 Jaewan Kim    2022-12-06  3231  						     struct cfg80211_pmsr_ftm_request_peer *request)
8027b096313ab2 Jaewan Kim    2022-12-06  3232  {
8027b096313ab2 Jaewan Kim    2022-12-06  3233  	void *ftm;
8027b096313ab2 Jaewan Kim    2022-12-06  3234  
8027b096313ab2 Jaewan Kim    2022-12-06 @3235  	if (!request->requested)
8027b096313ab2 Jaewan Kim    2022-12-06  3236  		return -EINVAL;
8027b096313ab2 Jaewan Kim    2022-12-06  3237  
8027b096313ab2 Jaewan Kim    2022-12-06  3238  	ftm = nla_nest_start(msg, NL80211_PMSR_TYPE_FTM);
8027b096313ab2 Jaewan Kim    2022-12-06 @3239  	if (!request)

if (!ftm) ?

8027b096313ab2 Jaewan Kim    2022-12-06  3240  		return -ENOBUFS;
8027b096313ab2 Jaewan Kim    2022-12-06  3241  
8027b096313ab2 Jaewan Kim    2022-12-06  3242  	if (nla_put_u32(msg, NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE,
8027b096313ab2 Jaewan Kim    2022-12-06  3243  			request->preamble))
8027b096313ab2 Jaewan Kim    2022-12-06  3244  		return -ENOBUFS;
8027b096313ab2 Jaewan Kim    2022-12-06  3245  
8027b096313ab2 Jaewan Kim    2022-12-06  3246  	if (nla_put_u16(msg, NL80211_PMSR_FTM_REQ_ATTR_BURST_PERIOD,
8027b096313ab2 Jaewan Kim    2022-12-06  3247  			request->burst_period))
8027b096313ab2 Jaewan Kim    2022-12-06  3248  		return -ENOBUFS;
8027b096313ab2 Jaewan Kim    2022-12-06  3249  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp


