Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573B2379775
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 21:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhEJTLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 15:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232133AbhEJTLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 15:11:42 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023CAC061574;
        Mon, 10 May 2021 12:10:37 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id v12so17715436wrq.6;
        Mon, 10 May 2021 12:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6+bq4nz+rZlWKieQDXLrXiknC/+/2IQfRO3qKHir+Kg=;
        b=LY9p9K5BwwB2LmZt6kOYadgROb/UJxgjqG81lSxqcud8iouZ8881V9Gxhpwg7SgH5W
         VPW/j9lg0ijIENiHjFPFkE2cnTQ2alcttpOxvs23v6e6ZpOYLosDWYoJ6rAN4hNZ44AK
         st/RPe2W1HlhkYDrYIUUIy75w5krEcITdq5pHlTKUFBxx5Fy1o3wz38kqKGWmTsGUIzb
         rbQMqUmfkED6mXQUvWJXF7z2KDBX36XiUbXjSugZUqVY6y71MqlKUJByxxvycOGOEN9b
         VOZk9R5lIsggTTQ3ENpUq4I6xbPT/rs3yrir6sHRbDIbvSVDKvaS9M0QL1u1iCvX/ILm
         K5SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=6+bq4nz+rZlWKieQDXLrXiknC/+/2IQfRO3qKHir+Kg=;
        b=qiHDwFGgIcZRO75C7IoZtaLpuPYUoIVJTxs7Q+tGrlZ4QLBfUPVp4LtF+GsA9nvZiF
         Z6DLI0Rd/+B1Twzyv+alKr9tUtKxW41DAPL+BJjXMCdF0KV/GkxXZYAHlvkbw/oMbf3t
         kUSTpWZ0ckUfLPKQVRPYh1GBUJlboEGI+HJjH6U4cyFAr2sh+cZuNXTregNU8TeHe7kM
         a974KQbVPPC6z8qbT+q7mZSVmcsElxQI4nKR4s1PiZB8ODgSEGR2V5AdMdUH2uJNYevh
         tlAnu1h1soO1R1pZnIJo6p/R8j44+53LXUEf0W+7+zFoazJ+abSD020Zst6frBCAEhg6
         cbcA==
X-Gm-Message-State: AOAM5315Mukkvk8uXGpvpYWPVumAaRqdhcVxq4H5/kM1nZPFMLtKra6l
        Eq7a7TN9WdahLMUaTjFinLU=
X-Google-Smtp-Source: ABdhPJzj0blzMZ1JdWdOAIGXMGxRDJTwHcz2f80yGo3HTnWvcTU04b2Mm8+c9uY/GSdGQQL8+wpHoA==
X-Received: by 2002:adf:e40c:: with SMTP id g12mr31973827wrm.11.1620673835643;
        Mon, 10 May 2021 12:10:35 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id r7sm19251571wmq.18.2021.05.10.12.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 12:10:34 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Mon, 10 May 2021 21:10:33 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Or Cohen <orcohen@paloaltonetworks.com>
Subject: Re: [PATCH net 0/2] sctp: fix the race condition in
 sctp_destroy_sock in a proper way
Message-ID: <YJmFKVqZWDRe5Rzn@eldamar.lan>
References: <cover.1619989856.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1619989856.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xin,

On Mon, May 03, 2021 at 05:11:40AM +0800, Xin Long wrote:
> The original fix introduced a dead lock, and has to be removed in
> Patch 1/2, and we will get a proper way to fix it in Patch 2/2.
> 
> Xin Long (2):
>   Revert "net/sctp: fix race condition in sctp_destroy_sock"
>   sctp: delay auto_asconf init until binding the first addr
> 
>  net/sctp/socket.c | 38 ++++++++++++++++++++++----------------
>  1 file changed, 22 insertions(+), 16 deletions(-)

The original commit which got reverted in this series, was already
applied to several stable series, namely all of 4.4.268, 4.9.268,
4.14.232, 4.19.189, 5.4.114, 5.10.32, 5.11.16.

Is it planned to do the revert and bugfix in those as well?

Regards,
Salvatore
