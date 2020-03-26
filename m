Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79F51194A54
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 22:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbgCZVPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 17:15:31 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37274 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbgCZVPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 17:15:30 -0400
Received: by mail-wm1-f68.google.com with SMTP id d1so9439860wmb.2
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 14:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V0HrVbuIrq8oEfZEE028HCLl2NNp7Ln7SWgCrnZ8w4I=;
        b=trJPR7TjMMr2HlI0yOzQTlZoqwkpIlZzbpPhnyQJjLGjWWICUBHxv8pUWPe6UDlKqa
         i5E9RVR+XyVZYz4p5kNu2QY8HMEUvuMebnzqFRO1kY7FPQp6rC7w1nU/W9cf90Yfa8JH
         CU1JUV21T7aPJrac6FuUBB8NUB60UCRpvMkndfmzpIw2885tWsDHTbftQUTXK/qECnr+
         dw0FyCQn7vV/34+7k/ZqDSYwsS9RlnNC67Sg6dtReIbHTlzwnQV3KEi2WemuFfrVHBZj
         wwAcxfbuXtxhmYS7PX2mZO4GjYtuqb2ps0E1A2Y+MHtL4f4VkltkWV3jV3XKblhl6P4i
         FA9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V0HrVbuIrq8oEfZEE028HCLl2NNp7Ln7SWgCrnZ8w4I=;
        b=FmkvT38Uuhy28DKuFK34CpM8gaJyVpR+ubHWeONuarcH5E4NawE6rl3kcHm49MmR2a
         tTT9ZjnxbWIdlDABWw16Op/sefqhbJ+ofuA79DKzvacVpFIt6KUVKYprjsdhiVXuy66A
         /VYNtuw0t/2MUqbBawS92zKWX40zlgXBEs3x5I2Z450oYH0lzEO4KgmqVvmTb3+hVbkl
         D1vYDEwXYUyWMNZ9j6ctXYTDwowKlsz61d5LCjjqssxvEEU/JdELn66REhSPQW7yebiH
         ZkcPnzjKZl8ylcIVA/dTxQqJKIc6lujfOLRSKYK09hu2GlZPLzonRj2Frb5Cv79y0Tk9
         Gypg==
X-Gm-Message-State: ANhLgQ0w7vU4NenCi7x+Z/IyqkKEfYApC8Ed6zV2pYrsTkYvsRz4navh
        vf4M3Gt1H1LVLvebqdGxjAFrVA==
X-Google-Smtp-Source: ADFU+vuF/3qhLshm0OWI7YoujlHx8FBxMH7KjJDBuZN8+b1zLDANSUnUMF9sEilygM4jsdGDv7nkhw==
X-Received: by 2002:adf:fc4c:: with SMTP id e12mr11306920wrs.265.1585257327694;
        Thu, 26 Mar 2020 14:15:27 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f207sm5425961wme.9.2020.03.26.14.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 14:15:27 -0700 (PDT)
Date:   Thu, 26 Mar 2020 22:15:26 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v3 06/11] devlink: extract snapshot id
 allocation to helper function
Message-ID: <20200326211526.GD11304@nanopsycho.orion>
References: <20200326183718.2384349-1-jacob.e.keller@intel.com>
 <20200326183718.2384349-7-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326183718.2384349-7-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 26, 2020 at 07:37:13PM CET, jacob.e.keller@intel.com wrote:
>A future change is going to implement a new devlink command to request
>a snapshot on demand. As part of this, the logic for handling the
>snapshot ids will be refactored. To simplify the snapshot id allocation
>function, move it to a separate function prefixed by `__`. This helper
>function will assume the lock is held.
>
>While no other callers will exist, it simplifies refactoring the logic
>because there is no need to complicate the function with gotos to handle
>unlocking on failure.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>

For the 3rd time. I'm not sure why you don't took this :/
