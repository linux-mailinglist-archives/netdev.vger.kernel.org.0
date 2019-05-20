Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAC023D8A
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 18:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389863AbfETQcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 12:32:54 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46056 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388890AbfETQcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 12:32:53 -0400
Received: by mail-qt1-f196.google.com with SMTP id t1so16982529qtc.12
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 09:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gnsyG4hrKIQnK4j5yazw8m1HGEGQAScyjntkoo9bGZ4=;
        b=LstlHw/falcS3e72J8tCML7wL74IZB8T9Oq2FIHcx/gVhQOn1gYPjB4uZepGLEY7cj
         csdgFELrheLCbDt4BGiTilwSp61VsPhgWAFSpc/mDUPjyQydXVJJ+zeqTprzYY+UaiZW
         R7DqG0prM+jrK+jsUb1FIs+j3/dsPv7NGGLXjoTqrL5IuJdx7Q9VjQMI2Nl3wlpjca0S
         hxESGUlAHRUkUak6T3iQhHhKdWXqGfAJ282DQM1JYvGFA5bAZjO9l1GnlJRWai3sPmj7
         HVC7ZUeokm2jT8c82D9OkxS/On6EFlDIZNavhx06PPt+1Tpne56R9onSNCLZrEvWk1h2
         L1qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gnsyG4hrKIQnK4j5yazw8m1HGEGQAScyjntkoo9bGZ4=;
        b=dWI+BvGruRJhsI41Oc3d4QzK4FfDxvs5RC9KhZVGStEot+Zfild/2K7j/iNQZ5r6Y5
         UHIQPm2KLty6Ok+iAhpbryvg/bB4eXhaub8hT+0mSNff+aLRiKUFb/xwUePgAtrVaSAk
         oTrkzAHRB8uhPO+EvPgts7/EJfTU75ixwC1mvAgNHImmgKvfnASKVs8bkG9qS569trOh
         nfgw3FBEV/67BnpH4Ibjv8StOfL5NMSRRpJcHXgcyJiGvGwHj4QZuFFcPkyjI0L4ynhu
         6ujhev9HKDssnELsvHlp57ET1du/g7HbZbGaLiGNZnYn2ZA+BlUi5mJvogx8tvLkpn2g
         I4TQ==
X-Gm-Message-State: APjAAAXbHGc3KUFaObbDdIzVYlfCK8R4f+wcc6Z+76qlsR+Uwb+Wh2XZ
        ZRnLmNnNs3dmTyEFxugtC2y2rg==
X-Google-Smtp-Source: APXvYqwzG7NFqsbcnkLJO5o08v7OiumYkxa5+jLkAj+MxH1MF/GQJbsu9mOeYMZATWeXUjMwShwpow==
X-Received: by 2002:a0c:b5ad:: with SMTP id g45mr35757255qve.231.1558369972868;
        Mon, 20 May 2019 09:32:52 -0700 (PDT)
Received: from [192.168.0.124] (24-212-162-241.cable.teksavvy.com. [24.212.162.241])
        by smtp.googlemail.com with ESMTPSA id f21sm7863589qkl.72.2019.05.20.09.32.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 09:32:52 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 0/3] flow_offload: Re-add per-action
 statistics
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     Edward Cree <ecree@solarflare.com>, Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <9b137a90-9bfb-9232-b01b-6b6c10286741@solarflare.com>
 <f4fdc1f1-bee2-8456-8daa-fbf65aabe0d4@solarflare.com>
 <cacfe0ec-4a98-b16b-ef30-647b9e50759d@mojatatu.com>
 <f27a6a44-5016-1d17-580c-08682d29a767@solarflare.com>
 <3db2e5bf-4142-de4b-7085-f86a592e2e09@mojatatu.com>
 <17cf3488-6f17-cb59-42a3-6b73f7a0091e@solarflare.com>
 <b4b5e1e7-ebef-5d20-67b6-a3324e886942@mojatatu.com>
Message-ID: <2bc5ab79-fe60-b5c3-6bfa-d4d32add11fe@mojatatu.com>
Date:   Mon, 20 May 2019 12:32:50 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <b4b5e1e7-ebef-5d20-67b6-a3324e886942@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-20 12:29 p.m., Jamal Hadi Salim wrote:

> Assuming in this case you added by value the actions? 
To be clear on the terminology:

"By Value" implies you add the filter and action in the
same command line.
"By Reference" implies you first create the action then
create a filter which binds to the already created action.

cheers,
jamal
