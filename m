Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 119F5174C5B
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 10:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgCAJAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 04:00:12 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41441 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgCAJAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 04:00:12 -0500
Received: by mail-wr1-f67.google.com with SMTP id v4so8601161wrs.8
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 01:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RgqUIkJ/V29gdIeilRkuEdKKih4CZ5CvCxN7LRBqXeY=;
        b=itFBcRDDUtben99TSRjGYYJ8GycYkjX3Lw3LkbqcjKF32+WYrCW4sRY4KF87btCneu
         kYZLaEVStbeXprvA6NNGY0RuAeNHLgRYsRED+9Bmg7eQu5OV8ynuzjPMfuHwzNmvksqm
         Tcsgy7oYHCZ+YVvwIVwZj/eaJ10BfneoLM6Oy5eJlPm8oaGSXmsJsnWkdZCgnjgyR68I
         yc2FfgaJ+VOf9v5Styp9H5Q0B8tiznpdgW96L1uMTElYPoqpECPEh5kSwOuYEtQ6xwfw
         hhshjBXllr86DG6U54n+FqmG8sbQNPfhary58YS3SvEukb1Lfdmjq7jwePIHcvLkCwXs
         BAKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RgqUIkJ/V29gdIeilRkuEdKKih4CZ5CvCxN7LRBqXeY=;
        b=qL7Uf4iNJD/q6DjjcukqaZdd2HEJ187JcPrG/Qp/plw6lkKm4Vn5aKlQrSi+9mmyHK
         Z1TdRgwlxlQTnJjeQNrEh/J1kF7O9+nX1qZtmDC1NrIVcHaHgOqxFP2KxVnlXKM2CEEo
         ChlEkjvW+vU4SfHWueirHABoIVp9C5eA8cug9EEwm5xbAfE1OCEjOjJGRix8IYNkl9Jn
         EPKQHawbpc+s3VImwu7Ld2d1zqtrK9jxJ7SkUrmXoohad4CPlKeoo+YxYLMZ3tZw1vFa
         U2Bci7HMkfOUEVqpeoJSJMJR3F5JvsA7CBSsky5IEPg/iwqKXiDbyP47AtGEzazFoS7n
         dwCw==
X-Gm-Message-State: APjAAAV59g/iuutgWt3v6oPR7umTf0Vs6LoikLQZH3RBH0Wo7ccN2F+L
        NLUpfU6zSDNEkN6ScqxVQbPwZg==
X-Google-Smtp-Source: APXvYqzo/Zy6zpwiWxmde5mEl8mzQ//9BzLaS/MxKmLH+s8LJy5xk1SU+oBtJx6fLOnb0a21hJENdg==
X-Received: by 2002:a5d:4b82:: with SMTP id b2mr15471955wrt.102.1583053210352;
        Sun, 01 Mar 2020 01:00:10 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id r30sm11602339wrc.34.2020.03.01.01.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 01:00:09 -0800 (PST)
Date:   Sun, 1 Mar 2020 10:00:09 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 03/12] flow_offload: check for basic action
 hw stats type
Message-ID: <20200301090009.GT26061@nanopsycho>
References: <20200228172505.14386-1-jiri@resnulli.us>
 <20200228172505.14386-4-jiri@resnulli.us>
 <20200228114056.5bc06ad2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200229074004.GL26061@nanopsycho>
 <20200229111848.53450ff1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200229111848.53450ff1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Feb 29, 2020 at 08:18:48PM CET, kuba@kernel.org wrote:
>On Sat, 29 Feb 2020 08:40:04 +0100 Jiri Pirko wrote:
>> Fri, Feb 28, 2020 at 08:40:56PM CET, kuba@kernel.org wrote:
>> >On Fri, 28 Feb 2020 18:24:56 +0100 Jiri Pirko wrote:  
>> >> @@ -299,6 +300,9 @@ static int bnxt_tc_parse_actions(struct bnxt *bp,
>> >>  		return -EINVAL;
>> >>  	}
>> >>  
>> >> +	if (!flow_action_basic_hw_stats_types_check(flow_action, extack))
>> >> +		return -EOPNOTSUPP;  
>> >
>> >Could we have this helper take one stat type? To let drivers pass the
>> >stat type they support?   
>> 
>> That would be always "any" as "any" is supported by all drivers.
>> And that is exactly what the helper checks..
>
>I'd think most drivers implement some form of DELAYED today, 'cause for
>the number of flows things like OvS need that's the only practical one.
>I was thinking to let drivers pass DELAYED here.
>
>I agree that your patch would most likely pass ANY in almost all cases
>as you shouldn't be expected to know all the drivers, but at least the
>maintainers can easily just tweak the parameter.
>
>Does that make sense? Maybe I'm missing something.

Well, I guess. mlx5 only supports "delayed". It would work for it.
How about having flow_action_basic_hw_stats_types_check() as is and
add flow_action_basic_hw_stats_types_check_ext() that would accept extra
arg with enum?
