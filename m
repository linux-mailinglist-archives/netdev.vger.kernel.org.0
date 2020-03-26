Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C30E194127
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgCZOUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:20:55 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35172 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgCZOUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:20:55 -0400
Received: by mail-pf1-f193.google.com with SMTP id u68so2850046pfb.2;
        Thu, 26 Mar 2020 07:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gPeImlN/4kP8RX9TOszH6BuHnCWb3KWaDZqn/u628D8=;
        b=NrYDtIadvKbOpncOQqfbnx0AsiDYdBgPc9QHvXckrIz+BFIwwt9/cX4HJl4a5QjLRc
         3Uf8G/i3cBrhAdQ8Q2SGWQLRhYcJ/tepOE+3cPwC5WjhJbyYEf1eUXmuSu7LqKgxvHrT
         UW6+KvFy0l+tOB2vxvJ4p2qjiDMk7VuaKrToeIaKIihYj/2FL8/muTwx0lXJzyJhWJXA
         //Kybuzp4tsLHKFRmcjo/Ix9FVkU3EuLNygY06QQE7jXSeiurwalihGs4WiqF+CePhh9
         hzobP7x8WXLUlxK6qaUepJFmh/mMMRsbjGE4nltqOZ0DZQNeQvJuQHugiDSucGqeQVYE
         t2zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gPeImlN/4kP8RX9TOszH6BuHnCWb3KWaDZqn/u628D8=;
        b=W3cui3J5a8qbvR26HMvcbq9LmZeIuePDyhWtO6ToK/mg2ZuuYJtE1pzonTrEeS2dro
         zXDr5XAUk94i5VpvkJndVa3mkiCa4WsErPw9Behhnnbip9gaS5KmJGx6Sxo1cy/3v4tZ
         17qRS1kvS6VcuTsfCs7B5JkBCKDGnQ51WfFMUfAcVI7nqCPhYhaD7ntvdl7z6L5ES8ET
         i4AKF5OIBGsGK0FSNlx15SWmSQTikWgG3Z0NSiAzep2O/Dn7ATxlyD8btJp9zoONDzUx
         6Zunl0wnXIc3UMncigY9V7AepOURRjOc1vCxCx+4q8UBrl17aJMrUX6l+YTATDxVHCeW
         ZH5g==
X-Gm-Message-State: ANhLgQ2eWk9ns7HIW6WGA2tDiBQTwe1oc9178inNV1LWSbk+z3Jn79HC
        ILM3qK4JggubhWEjpNhhqVm7wI9Q
X-Google-Smtp-Source: ADFU+vvrj+Fqajh3bX3UxpmE1jRrTWUDqmYUvT0Q0lJE1A12T5dY7WojtGeF1pcSk21xEANuJpDBdw==
X-Received: by 2002:aa7:8f3a:: with SMTP id y26mr9020298pfr.180.1585232452388;
        Thu, 26 Mar 2020 07:20:52 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id x15sm1748743pfq.107.2020.03.26.07.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 07:20:51 -0700 (PDT)
Date:   Thu, 26 Mar 2020 07:20:49 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        netdev <netdev@vger.kernel.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 03/11] net: ethernet: ti: cpts: move tc mult
 update in cpts_fifo_read()
Message-ID: <20200326142049.GD20841@localhost>
References: <20200320194244.4703-1-grygorii.strashko@ti.com>
 <20200320194244.4703-4-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320194244.4703-4-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 09:42:36PM +0200, Grygorii Strashko wrote:
> Now CPTS driver .adjfreq() generates request to read CPTS current time
> (CPTS_EV_PUSH) with intention to process all pending event using previous
> frequency adjustment values before switching to the new ones. So
> CPTS_EV_PUSH works as a marker to switch to the new frequency adjustment
> values. Current code assumes that all job is done in .adjfreq(), but after
> enabling IRQ this will not be true any more.
> 
> Hence save new frequency adjustment values (mult) and perform actual freq
> adjustment in cpts_fifo_read() immediately after CPTS_EV_PUSH is received.

Now THIS comment is much better!  The explanation here really should
be in the previous patch, to help poor reviewers like me.

Thanks,
Richard
 
