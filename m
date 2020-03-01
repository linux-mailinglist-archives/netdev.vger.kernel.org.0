Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78C70174C50
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 09:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgCAIrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 03:47:20 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41583 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgCAIrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 03:47:19 -0500
Received: by mail-wr1-f67.google.com with SMTP id v4so8581497wrs.8
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 00:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lRQE3W8UHvVs5VqDbBwCNto7mblqacnoftGb6cDneVE=;
        b=qM66H4A3ITvWgnxdBkUfhvHiWWKf4BIBfY7Iff9xoFaGpzzncsL/sAOanqKVE//bGY
         UfNvuGQV/ibAJB/eivwZeS839IZYGzxjzLU+EgYdDZ0f/BWmF2vBSiSaMulxubLo3egQ
         9C2xGYgdfBbj0HI/7h70SYneDMEJCgwSKgEWi7P6oxKEcqAO9I4qo+0NoFJNCTBQ+4Ug
         RnRzMojSSZyRF2ogDvAnCKvKp3m319B4+TFWSddu0iey2Q29gx7YK5IWl86qF6J9kbUp
         Ow5YAUIXEkjyANq0b5tNUHyyxTrCK2cqiQ/lz8MS88gg9aUis1nSzKiJ5Poj8bpt5Emm
         pgsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lRQE3W8UHvVs5VqDbBwCNto7mblqacnoftGb6cDneVE=;
        b=j7D3sH2EyD1/IourmDilULQUV5tbFnfLMKqQUGr3/IcrWVS3qz8AZGHv1+qeR5mTC7
         17uxylm3cVkZ2Y5X1eRzS6bVzIVEmJl5O6fNGbpWn4H2eNewgPkELYbURPowpC+PA+fU
         q0gUDkIdVQ3XWvyGk5mtz8YVe4fm0V0mF2nSujBxkqIVRKYxXUyYBYBmBfJLzvT/o0G5
         pNEA7R2Qh44IFGHniMWDOWkYc+LS4Jk7TB1odyqDyNjtrJCl226Yuq9l1I1kNh5AJT/R
         xZaczlYIF4Jlk72PRrNnf+uGeMkgxMXORB9LTP85WQBZplvqs4D8qwT+XVYklH7dsUiN
         fv1Q==
X-Gm-Message-State: APjAAAWlmBKa2K7QrxIaOX1mfYxawVYof+UVP2OED8EvXOiQ0G2c5hnL
        FOHCeAgjqF5VRD0tWeCYyAGiAw==
X-Google-Smtp-Source: APXvYqyAB0MUZ2/xQdM9DLzTxktXTp1zntoTdgjZ3KI+dlv/bwgK6an6IybVVPSiM0dVBF/UlCL8fQ==
X-Received: by 2002:adf:ebca:: with SMTP id v10mr15543707wrn.307.1583052437754;
        Sun, 01 Mar 2020 00:47:17 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id q3sm9342556wmj.38.2020.03.01.00.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 00:47:17 -0800 (PST)
Date:   Sun, 1 Mar 2020 09:47:16 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        saeedm@mellanox.com, leon@kernel.org, michael.chan@broadcom.com,
        vishal@chelsio.com, jeffrey.t.kirsher@intel.com,
        idosch@mellanox.com, aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 08/12] flow_offload: introduce "immediate" HW
 stats type and allow it in mlxsw
Message-ID: <20200301084716.GR26061@nanopsycho>
References: <20200228172505.14386-1-jiri@resnulli.us>
 <20200228172505.14386-9-jiri@resnulli.us>
 <20200229193217.ejk3gbwhjcnxlk3c@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200229193217.ejk3gbwhjcnxlk3c@salvia>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Feb 29, 2020 at 08:32:18PM CET, pablo@netfilter.org wrote:
>On Fri, Feb 28, 2020 at 06:25:01PM +0100, Jiri Pirko wrote:
>[...]
>> @@ -31,7 +31,8 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
>>  
>>  	act = flow_action_first_entry_get(flow_action);
>>  	switch (act->hw_stats_type) {
>> -	case FLOW_ACTION_HW_STATS_TYPE_ANY:
>> +	case FLOW_ACTION_HW_STATS_TYPE_ANY: /* fall-through */
>> +	case FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE:
>
>This TYPE_ANY mean that driver picks the counter type for you?

Driver pick any counter, yes.

>
>Otherwise, users will not have a way to know how to interpret what
>kind of counter this is.

User does not care in this case.
