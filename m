Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6A32296A9
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 12:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgGVKxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 06:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbgGVKxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 06:53:54 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDA2C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 03:53:53 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id o11so1440205wrv.9
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 03:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rTkSQC5SS9U/ecRovnotG8OexmDCR0ZPdBBWJzXyV7U=;
        b=lijpLiMFQ8/4bvw4oRFg7dEVm6KcYeEXeEpWTChaXBTyuZHwkTQTHvpOu+48SW7Dmi
         Xu+lx1JSdjqsG0/n1aL4RDcTBXGVMlt1ijEvlmGRKtlPVcPTt8geE21+ZqRjn64gQYmD
         q+RAc16525Q4adTDMuVtOvwsxHbQ7Qi7tSrMhREffIz7LvwoDioLylaszAC6EhXULbUG
         kZnsgPxS2ElmzBQ0mf92ylmvdZBMdP7OhGdG+okAjhnPRdf49Rp/SuQgYY8y7SpqiG0T
         Phl0qcwAe9uYcqdTtfgzmk1QnFoMXY706coBiC1H8gPjXGojKqPYO1dzHiUdv6Xyqfat
         EXEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rTkSQC5SS9U/ecRovnotG8OexmDCR0ZPdBBWJzXyV7U=;
        b=ZJGfBw3D1kBN9bHqhlHx2X3bCZs7d18topV294EJwtsz0p86P72IfzTILpQVVwnI/8
         VuYPuK+eCk41pjNoHW/hKws4U1JZd6GUzliKXS1Pp5oLEVlLH1rINuxTTZpTIG/X33zl
         4Ij1rnZVTgF8i14z6xTrtd5n3UQU5hAzVm3amuEIN8pzEHbZnhKKi836B8WNoHRDpPxC
         tFQsXUJkJjQ3sHU1j6kBt5H/XDEXtVlrY/Z9+e/KknarVrdlTcvQwGT4i/Q1CG+6LoZV
         HXKoKm3Wh0ojwac8sckaslzVfXLpzlKRb1AfhJU1t2aJVI0/NBTMGjPTsOSltsxJfGl9
         bfqg==
X-Gm-Message-State: AOAM53125iKYYKnUnyWA8h27vIgRiuMJfM9G6Nkky8mO8GOLMik2/LT7
        3cnpoxaVNkPlv/43bFjf2PVpTg==
X-Google-Smtp-Source: ABdhPJyyJrlkx6WRl2+Dkh5PyIVO3B9h9o/QJSAehU0CS9d6v2f24yqnRICGc85gP7GRCW3y1ek8Ug==
X-Received: by 2002:adf:9051:: with SMTP id h75mr32820339wrh.152.1595415232552;
        Wed, 22 Jul 2020 03:53:52 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id x204sm4019891wmg.2.2020.07.22.03.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 03:53:52 -0700 (PDT)
Date:   Wed, 22 Jul 2020 12:53:51 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Ido Schimmel <idosch@mellanox.com>, mlxsw@mellanox.com
Subject: Re: [patch net-next v2] sched: sch_api: add missing rcu read lock to
 silence the warning
Message-ID: <20200722105351.GB3154@nanopsycho>
References: <20200720081041.8711-1-jiri@resnulli.us>
 <CAM_iQpVZLGiDR_foe7HdaW0-f5kO+5+Mm6p1e59tb2_VASFpHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpVZLGiDR_foe7HdaW0-f5kO+5+Mm6p1e59tb2_VASFpHA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 21, 2020 at 08:57:45PM CEST, xiyou.wangcong@gmail.com wrote:
>On Mon, Jul 20, 2020 at 1:10 AM Jiri Pirko <jiri@resnulli.us> wrote:
>> diff --git a/include/linux/hashtable.h b/include/linux/hashtable.h
>> index 78b6ea5fa8ba..f6c666730b8c 100644
>> --- a/include/linux/hashtable.h
>> +++ b/include/linux/hashtable.h
>> @@ -173,9 +173,9 @@ static inline void hash_del_rcu(struct hlist_node *node)
>>   * @member: the name of the hlist_node within the struct
>>   * @key: the key of the objects to iterate over
>>   */
>
>I think you need to update the doc here too, that is adding @cond.

Ah, sure, will send v3. Thanks!
