Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3B872A201
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 02:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbfEYAI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 20:08:57 -0400
Received: from mail-vs1-f44.google.com ([209.85.217.44]:44240 "EHLO
        mail-vs1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfEYAI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 20:08:56 -0400
Received: by mail-vs1-f44.google.com with SMTP id w124so7010361vsb.11
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 17:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=UhpTZ0DAyxwQy2pYL5mrd5rwWTTXgLbenh/CMM+EB9s=;
        b=GVL3dgHzHvYvfN6H4Vws2xTD+0JAknspSUZ4lifAyZ4v6iS7PmRt1TcfF8wmZmsn3X
         NLoSjrdASaz24vvgsUkKrGC29ZSyeAytgqVXJuAkU0cAarPOHupF2u0B4N/NaDwTyDkH
         fW/D2Fo66z39+XewYUra6pMzIqs0PwpKKY2bqM3//UFUKp3s+p0mKS7BWevU1GEY90kp
         2clCrDvmsvpo4O989PEc1YDGLuMGTv1pN8zv0+BOBDa28q4kLMhrczLsTCO3/5pWb9Fh
         +BmGjLmF1fMgQUgQB7i0Rmc/+Qevh7skzv5f6TsKYQl6AsBt4yfrUVWeHiVvA3c3cA4v
         MgFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=UhpTZ0DAyxwQy2pYL5mrd5rwWTTXgLbenh/CMM+EB9s=;
        b=W5ub81EdTBHVk1UaZCWMiUAfrtfKeikinq1jaAZFGVoP+5MoFbsj5TPEqcQNl27Ss5
         R/BGju560/h0rCyCVLN77ERWTo2JXCmeV8rySg1A1ktDo8XGXkHamk0lv7H3LLUYJoay
         KfGRWBO0BZeyxYfZQD606z5wJf/5nANCK3IijAG9DPvLY+mHLltt55sBcc0JfMg2w0T6
         L7ys6WrfXutJEL7A0QQFwrGU81Qcpn2BGlPKpSchVmVtT9TcklAyip0oKndYdmQa0VIi
         oqs7m+ciP+sxuDLOqFSCXRy2vOcwWoEFVo3+j4srk5/HtpSSkAAtOvGGxUH9GroIfNxG
         oQkg==
X-Gm-Message-State: APjAAAWj16DouK+jI7QFVt9L7leX67AJSuSS5vN8/aeiE1dLYy3O50lY
        v95nkuk++peQ+LFexBGA+nT7+w==
X-Google-Smtp-Source: APXvYqz6RYIsWgHQaPn+SMWVSKk7rK/4nb5JPJaRjjDGRjih2Z7v/BdB+pH4HQ/Wcz/qFbKJwy3iKw==
X-Received: by 2002:a67:f3c5:: with SMTP id j5mr3432366vsn.232.1558742935717;
        Fri, 24 May 2019 17:08:55 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c192sm2910289vkd.31.2019.05.24.17.08.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 24 May 2019 17:08:55 -0700 (PDT)
Date:   Fri, 24 May 2019 17:08:52 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>, David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        sthemmin@microsoft.com, saeedm@mellanox.com, leon@kernel.org
Subject: Re: [patch net-next 3/7] mlxfw: Propagate error messages through
 extack
Message-ID: <20190524170852.4fea5e77@cakuba.netronome.com>
In-Reply-To: <20190524222635.GA2284@nanopsycho.orion>
References: <20190523094510.2317-1-jiri@resnulli.us>
        <20190523094510.2317-4-jiri@resnulli.us>
        <7f3362de-baaf-99ee-1b53-55675aaf00fe@gmail.com>
        <20190524081110.GB2904@nanopsycho>
        <20190524085446.59dc6f2f@cakuba.netronome.com>
        <20190524222635.GA2284@nanopsycho.orion>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 May 2019 00:26:35 +0200, Jiri Pirko wrote:
> Fri, May 24, 2019 at 05:54:46PM CEST, jakub.kicinski@netronome.com wrote:
> >On Fri, 24 May 2019 10:11:10 +0200, Jiri Pirko wrote:  
> >> Thu, May 23, 2019 at 05:19:46PM CEST, dsahern@gmail.com wrote:  
> >> >On 5/23/19 3:45 AM, Jiri Pirko wrote:    
> >> >> @@ -57,11 +58,13 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
> >> >>  	if (fsm_state_err != MLXFW_FSM_STATE_ERR_OK) {
> >> >>  		pr_err("Firmware flash failed: %s\n",
> >> >>  		       mlxfw_fsm_state_err_str[fsm_state_err]);
> >> >> +		NL_SET_ERR_MSG_MOD(extack, "Firmware flash failed");
> >> >>  		return -EINVAL;
> >> >>  	}
> >> >>  	if (curr_fsm_state != fsm_state) {
> >> >>  		if (--times == 0) {
> >> >>  			pr_err("Timeout reached on FSM state change");
> >> >> +			NL_SET_ERR_MSG_MOD(extack, "Timeout reached on FSM state change");    
> >> >
> >> >FSM? Is the meaning obvious to users?    
> >> 
> >> It is specific to mlx drivers.  
> >
> >What does it stand for?  Isn't it just Finite State Machine?  
> 
> I believe so.

In which case it doesn't really add much, no?  I second David's request
to make the messages as easy to understand as possible.  

PSID for better or worse I have previously capitulated on, so I guess
the ship has indeed sailed there :)

$ grep -A4 psid -- Documentation/networking/devlink-info-versions.rst 
fw.psid
=======

Unique identifier of the firmware parameter set.
