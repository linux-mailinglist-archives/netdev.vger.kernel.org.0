Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A42127FF59
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 14:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732018AbgJAMl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 08:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731828AbgJAMl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 08:41:26 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF4AC0613D0;
        Thu,  1 Oct 2020 05:41:26 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id d1so4151987qtr.6;
        Thu, 01 Oct 2020 05:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eob6aliylOP56SVG/KL44/iJ0VOS5gnp/UrUcw5CeJc=;
        b=SXwzKLKNRDqOjVIPGGkRyJCGqxgQRbhQkZ3hp/4aNqVBpD2sOiXKmq1w1brfSRLyQT
         DlklZ/mWW6SRZKs2W0cynOcyDdS1U7tI3zJDjL9NFssgGkvrts+wawWEbhvCGzcv5NNK
         XwgmnpJ/ZZGoP2E8oo4Lrcn4dLPPmBrLlFt4n6bHW8kUAWpR8yCNF9/CrJf+P1OU9Ykm
         QitiCSaHGuD/npBZNNSQXnCpujtQ6axA//7JeHFXgdWZ/0h34MtUzegwWAHCSfo5kEpD
         62b2d4wRHrDYm+0u0hVNA8SoSZP3e51RVdZZh07hQpQx8ohdMPVQyK9uHNRy5xR6RxXB
         s00g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eob6aliylOP56SVG/KL44/iJ0VOS5gnp/UrUcw5CeJc=;
        b=SZ0XT4BsES1fh7kaou+Am1ivb2VwgAh0ENiWvvYJSaY6RAN9e4dkTEy1zRafXdVyck
         zogPB3P+ZSiPTN44ehTRFrheSq0sLrLzJxcE08YfKt5W7WI5v+6aVAGfNPqx3P0uguuw
         LmK1BLNZsfWPxwWSwXsBtrjmiEoJuN65YcLfUIgigws2rR43CE+bwHgTvugzXCwtowpk
         XhyilHgM/hIzm8Wf7RyN8CXagHhT/nMNUmdnBWg2L8N2AqkvnAgomv5tZPXUKgQ0ufBY
         V5Jf5Eip85xPI1m6GhnCEWGL3TzfEV3SthIFw0IbrhHkDXBooiYaETSyrKMCXwSDHmrb
         bNOg==
X-Gm-Message-State: AOAM530nFPmoXflXXJlURLmXT8G59rBwDF1kH3WFndB+U3aCCrOG5LGS
        Ey9HsM0woMJZJ9Ia+zZcE0XgG1AW2BA=
X-Google-Smtp-Source: ABdhPJyB5PWorJxRCkn0qw1+HtsZGPXCZZRmeoxlPe+MRTZjAvISHfKGkaAu/Nfsxn+TDZfFV5FwUA==
X-Received: by 2002:ac8:4e4e:: with SMTP id e14mr7331540qtw.49.1601556085360;
        Thu, 01 Oct 2020 05:41:25 -0700 (PDT)
Received: from localhost.localdomain ([177.220.174.180])
        by smtp.gmail.com with ESMTPSA id 184sm5765131qkl.104.2020.10.01.05.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:41:24 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 1FA45C6195; Thu,  1 Oct 2020 09:41:22 -0300 (-03)
Date:   Thu, 1 Oct 2020 09:41:22 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem@davemloft.net
Subject: Re: [PATCH net-next 00/15] sctp: Implement RFC6951: UDP
 Encapsulation of SCTP
Message-ID: <20201001124122.GB70998@localhost.localdomain>
References: <cover.1601387231.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1601387231.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 09:48:52PM +0800, Xin Long wrote:
...
> Patches:

Please give me till tomorrow for revising this patchset.

Thanks,
Marcelo
