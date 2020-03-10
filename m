Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 309B617F62A
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 12:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgCJLWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 07:22:19 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54952 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgCJLWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 07:22:19 -0400
Received: by mail-wm1-f67.google.com with SMTP id n8so928300wmc.4
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 04:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=qiBAoDPOsn6oF6bG0zw0HOqxA9k5RJQ/SsmIPTfCx8s=;
        b=h21tr5iIQt8xBWcSkk/fWEK1+IaDILJUbtG7z6dAbnk971bPAndplQ1sYH/1GF2AfX
         2V9+uayi8xC4qIHbzRj/w7Dy7YZtUGdk/atW69UFzyGIXqR6UVbWkycxJefcVpqr2eAp
         /AXDGVr0pi+NRHylSzMOEm7BUOKRicmvU6nJTNsV9UYIasldeDhihDDvFBT4pXY6quEp
         w4REEbVFA7sZcpkk6yhwfxLEAHLmZbEkEK35aJsFXbz+faJDqVHCIte3hoUPVpW5/BQ3
         mL09TbjU8xgQFiQUAwvyIHXtz3l4cnqpIjR9ArvC3P5TRxRX+ssI/+xBsV8BEjyv5HPL
         7SrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=qiBAoDPOsn6oF6bG0zw0HOqxA9k5RJQ/SsmIPTfCx8s=;
        b=FeZzn164uKdHsx4jfBB7p08m0PAvbnIiewFDkEoTK6f1yLqjAl3OMS0JCCjih4WNg3
         fPkdrwJ7h8HP6zAh3yFpRRFeI2apPnadG66GRDltqDriiwpLYpTk4fqYGdMRx02R2oqH
         lPtxFeD9KBMt+ymXTeCyD9oRWJ0jRzTV5Dn+6WsBKGJoHSTbxG/ogoYoyJ3n2iSIhv5S
         N6Ec/Q70gqaWP7qSB9JQz9JFNLjSPgbfyhSUbdGPcHeah99gpQ5GflrrjmLwYSp/apJ5
         bpsqmx+58JV977JtK6gn40ksMvjWODjwQyujMD0EFDkyJJmfsZMbxVfHGbIqjOQ//vd5
         flug==
X-Gm-Message-State: ANhLgQ2nM8cXq0zsGO03B5Ezlz7iCNJpNOVeHMAzQZ1IBm/N42+pTBWp
        wH+yRj9SU7lyH7X5Sk5vyM/WSA==
X-Google-Smtp-Source: ADFU+vtR8UfBGen6qTkXT7x5cIuARYeLb6c1x8USRqSugOuKMYdqCYXDrbRPM6jf/8E9fZtj6+Qnsw==
X-Received: by 2002:a05:600c:291a:: with SMTP id i26mr1753166wmd.161.1583839335486;
        Tue, 10 Mar 2020 04:22:15 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id a7sm3696861wmb.0.2020.03.10.04.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 04:22:15 -0700 (PDT)
Date:   Tue, 10 Mar 2020 12:22:14 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Edward Cree <ecree@solarflare.com>, netdev@vger.kernel.org,
        davem@davemloft.net, saeedm@mellanox.com, leon@kernel.org,
        michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org, mlxsw@mellanox.com
Subject: Re: [patch net-next v4 01/10] flow_offload: Introduce offload of HW
 stats type
Message-ID: <20200310112214.GB2295@nanopsycho.orion>
References: <20200307114020.8664-1-jiri@resnulli.us>
 <20200307114020.8664-2-jiri@resnulli.us>
 <1b7ddf97-5626-e58c-0468-eae83ad020b3@solarflare.com>
 <20200309143630.2f83476f@kicinski-fedora-PC1C0HJN>
 <75b7e941-9a94-9939-f212-03aaed856088@solarflare.com>
 <20200309153817.47c97707@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200309153817.47c97707@kicinski-fedora-PC1C0HJN>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Mar 09, 2020 at 11:38:17PM CET, kuba@kernel.org wrote:
>On Mon, 9 Mar 2020 22:27:59 +0000 Edward Cree wrote:
>> > Driver author can understandably try to simply handle all the values 
>> > in a switch statement and be unpleasantly surprised.  
>> In my experience, unenumerated enum values of this kind are fully
>>  idiomatic C; and a driver author looking at the header file to see
>>  what enumeration constants are defined will necessarily see all the
>>  calls to BIT() and the bitwise-or construction of _ANY.
>> I'm not sure I believe a naïve switch() implementation is an
>>  "understandable" error.
>
>Could be my slight exposure to HDLs that makes me strongly averse to
>encoding state outside of a enumeration into a value of that type :)
>
>> How about if we also rename the field "hw_stats_types", or squeeze
>>  the word "mask" in there somewhere?
>
>That'd make things slightly better.

It is not a mask though...
