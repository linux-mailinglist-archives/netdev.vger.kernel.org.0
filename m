Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE8C1D7C5D
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 17:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgERPIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 11:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgERPIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 11:08:20 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3B1C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 08:08:19 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id u22so4334183plq.12
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 08:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=leK+X2eSKz9USd5xIjweoqVaRVpxE51A0md9qK+OHN0=;
        b=oGcrJsJFk3mf71gSBYFedKdtGK8kGKAxWfUmv8BGWxB96yZg1NbnrRUfPuOyI71cCO
         uRVo3kbRtcC9aTGFVy3eUvLyqJJFyhDzK5ekqbq37Nl49jTOoxNjaDvJ9hadQzNObX/J
         iT/K7h0ZvA5MQrpKwkJ/F0QjsU6zOimHjxdt5/jPQqmlAQyElIiMqJJwbLlVBhW95J82
         y2JU7MwAYuz6aXwA/IHsKQHHmTlg4g71WzTkh4BXy41iFbwogdEpvETAV8/64C7DhNR4
         5EyPPU8acejVRpib4ABBUal7JrBAR25N5u1CjbLrfSwb2feapIzZ0iklQhh0Y3PZcz5/
         s8oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=leK+X2eSKz9USd5xIjweoqVaRVpxE51A0md9qK+OHN0=;
        b=HP5DklEd+Z8d5M3w+dJHgOpGeOyqX6SX+0VNUBdiA0rlQKn1LuH+nFd1V+cFDCwncQ
         4aJ8I6NZFPRtCjkdyAstr2hbe3HT6aCo5gGgf4wB4/4dyLz31DtPd028gXmoUGuetkXK
         RBAEjvkvoZTwNhBoBEyP8gkVMmrmFpuLhyPH5xBfbs7WwVY0UJuYuF1LMbVpHWuM6B6f
         xCkUwgtVJ8FXxumIymF875TgF5KvFbbc4pxWJIJDcX3Fh6uJfksog2pu58KwTKC5AyvP
         4X+4R5XR08I+kk51eH/4fVjNaZz5y3sEhXJ7L43XKMVg0ZK68t9pW3mi67yBqeGHZgFY
         73pw==
X-Gm-Message-State: AOAM530OXqLcKZhcWmFrsSpRBHCoxm9R7dTVhlHWfgxboc+/siUPZHZS
        sVtHzuxkEgvcaacRYvp8vy1rkg==
X-Google-Smtp-Source: ABdhPJwK3bqTqCP8Z++G4LPiOidzxgCkX9S/U5cUkIAy+JQUoH8ZTXQoGtRR/GrbnpgQWaZytmM9LA==
X-Received: by 2002:a17:902:c403:: with SMTP id k3mr16939639plk.12.1589814498683;
        Mon, 18 May 2020 08:08:18 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id e26sm5297455pff.137.2020.05.18.08.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 08:08:18 -0700 (PDT)
Date:   Mon, 18 May 2020 08:08:10 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org, kiran.patil@intel.com
Subject: Re: [PATCH iproute2-next] tc: mqprio: reject queues count/offset
 pair count higher than num_tc
Message-ID: <20200518080810.568a6d28@hermes.lan>
In-Reply-To: <20200513194717.15363-1-maciej.fijalkowski@intel.com>
References: <20200513194717.15363-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 May 2020 21:47:17 +0200
Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:

> Provide a sanity check that will make sure whether queues count/offset
> pair count will not exceed the actual number of TCs being created.
> 
> Example command that is invalid because there are 4 count/offset pairs
> whereas num_tc is only 2.
> 
>  # tc qdisc add dev enp96s0f0 root mqprio num_tc 2 map 0 0 0 0 1 1 1 1
> queues 4@0 4@4 4@8 4@12 hw 1 mode channel
> 
> Store the parsed count/offset pair count onto a dedicated variable that
> will be compared against opt.num_tc after all of the command line
> arguments were parsed. Bail out if this count is higher than opt.num_tc
> and let user know about it.
> 
> Drivers were swallowing such commands as they were iterating over
> count/offset pairs where num_tc was used as a delimiter, so this is not
> a big deal, but better catch such misconfiguration at the command line
> argument parsing level.
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  tc/q_mqprio.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/tc/q_mqprio.c b/tc/q_mqprio.c
> index 0eb41308..f26ba8d7 100644
> --- a/tc/q_mqprio.c
> +++ b/tc/q_mqprio.c
> @@ -48,6 +48,7 @@ static int mqprio_parse_opt(struct qdisc_util *qu, int argc,
>  	__u64 max_rate64[TC_QOPT_MAX_QUEUE] = {0};
>  	__u16 shaper = TC_MQPRIO_SHAPER_DCB;
>  	__u16 mode = TC_MQPRIO_MODE_DCB;
> +	int cnt_off_pairs = 0;

Since opt.num_tc is u8, shouldn't this be u8 as well?
Note: maximum number of queue is TC_QOPT_MAX_QUEUE (16).
