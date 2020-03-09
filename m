Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A495B17E5CD
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 18:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbgCIReP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 13:34:15 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41757 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727254AbgCIReO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 13:34:14 -0400
Received: by mail-wr1-f67.google.com with SMTP id v4so12317553wrs.8
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 10:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=7BtSXHM6bpU1ghUOCtb/9O0kKQoQV+A7kwwzPyBvR7A=;
        b=pAOe+dghcG8JdcyczZy0gpO4ONc1lY1Eio03T5lD6EBtq6JF7aqUQmfr34xwAQqWtF
         OdEp2lWJF32nk6jF/s6gI0XyLHypt/OgTNzyYOfcG/lctoQOv9gJNOVWVYBtswzfWSIB
         w7EhphtTO7umGgz2LPWKWRg2gZXuByE/7XgLh6H6vtrcO7ElchxQ5aZrQGWqZ2eu670c
         /8fmEEryvjMVSenpJls7jZJpD43WS8fyeXTpxhrMJpKFd+Oxg03g/ZFzHBy2cxN1igzq
         AcPNEWW5TDUoioOtkZq70fpzMrTH9jt0W94f3nylG0a316JbRAh1bc/g7QX74xxn+y6f
         TWPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=7BtSXHM6bpU1ghUOCtb/9O0kKQoQV+A7kwwzPyBvR7A=;
        b=NJZMS2MjeIaxwKxnP4wRu+6F/1nYVrzu89TrV+wt4Znj8o9tBGcLFUDQgCmeIVI8Iu
         CJ9j3SXEk3xQXPG0JiyAUTu2hMRODmHigSVEQEXunH5oJKshK0Ez2ccJoMyIz55bzzAc
         j6Db79T9gylnUld6R7U3GHK0geOnyXECdQ6PjmScF4F4ogWptMeLPCQvzALQAKJy90xk
         54WS7q5E1v9+xzfC3ci1AMJcVG6uPHcWeHtrpUJLKpA+adsjzCnz9OdwaQgMUiM2GWSo
         UbdXBlweRp6UMCPnVBPJJoMJE9Jdvlhg/TtlB+IpdHynyJUq6H7j33NTm+jAj3VRIFFk
         aUJw==
X-Gm-Message-State: ANhLgQ1j+0eeuTXGTdgB7HXSvsDrnV/5bLS0erqIuNAUbUagDX9y2GLm
        jIFhtot/nBFhkAu1yilskbpncQ==
X-Google-Smtp-Source: ADFU+vueOleS5BAq9Hiusjixd7LKBfXDpzJPq2Z9Ek4Aimatb/U2VGZsTpCxhGjVBBYn9GGq6plCpw==
X-Received: by 2002:adf:f105:: with SMTP id r5mr21989971wro.314.1583775253377;
        Mon, 09 Mar 2020 10:34:13 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id a5sm1217800wrw.62.2020.03.09.10.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 10:34:12 -0700 (PDT)
Date:   Mon, 9 Mar 2020 18:34:12 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Edward Cree <ecree@solarflare.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        saeedm@mellanox.com, leon@kernel.org, michael.chan@broadcom.com,
        vishal@chelsio.com, jeffrey.t.kirsher@intel.com,
        idosch@mellanox.com, aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org, mlxsw@mellanox.com
Subject: Re: [patch net-next v4 01/10] flow_offload: Introduce offload of HW
 stats type
Message-ID: <20200309173412.GF13968@nanopsycho.orion>
References: <20200307114020.8664-1-jiri@resnulli.us>
 <20200307114020.8664-2-jiri@resnulli.us>
 <1b7ddf97-5626-e58c-0468-eae83ad020b3@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1b7ddf97-5626-e58c-0468-eae83ad020b3@solarflare.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Mar 09, 2020 at 05:52:16PM CET, ecree@solarflare.com wrote:
>On 07/03/2020 11:40, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>>
>> Initially, pass "ANY" (struct is zeroed) to the drivers as that is the
>> current implicit value coming down to flow_offload. Add a bool
>> indicating that entries have mixed HW stats type.
>>
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>> v3->v4:
>> - fixed member alignment
>> v2->v3:
>> - moved to bitfield
>> - removed "mixed" bool
>> v1->v2:
>> - moved to actions
>> - add mixed bool
>> ---
>>  include/net/flow_offload.h | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>> index cd3510ac66b0..93d17f37e980 100644
>> --- a/include/net/flow_offload.h
>> +++ b/include/net/flow_offload.h
>> @@ -154,6 +154,8 @@ enum flow_action_mangle_base {
>>  	FLOW_ACT_MANGLE_HDR_TYPE_UDP,
>>  };
>>  
>> +#define FLOW_ACTION_HW_STATS_TYPE_ANY 0
>I'm not quite sure why switching to a bit fieldapproach means these
> haveto become #defines rather than enums...
>
>> +
>>  typedef void (*action_destr)(void *priv);
>>  
>>  struct flow_action_cookie {
>> @@ -168,6 +170,7 @@ void flow_action_cookie_destroy(struct flow_action_cookie *cookie);
>>  
>>  struct flow_action_entry {
>>  	enum flow_action_id		id;
>> +	u8				hw_stats_type;
>... causing this to become a u8with nothing obviously preventing
> a HW_STATS_TYPE bigger than 255 getting defined.

I don't follow.


>An enum type seems safer.

Well, it's is a bitfield, how do you envision to implement it. Have enum
value for every combination? I don't get it.


>
>-ed
>
>>  	action_destr			destructor;
>>  	void				*destructor_priv;
>>  	union {
>
