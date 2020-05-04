Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAEB1C407D
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 18:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbgEDQwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 12:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729663AbgEDQwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 12:52:23 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0294C061A0E;
        Mon,  4 May 2020 09:52:22 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id t40so76933pjb.3;
        Mon, 04 May 2020 09:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EIJn9teWUiLNl3ikQxdGr47kMKy7GKhGJibMs59WMAc=;
        b=MNgbfsMcWMA5J22qoSta4jNZ/3owA0SEmQ87liv0wdm7MJF4SUALIEBie7GuWGiUrT
         pW9UkykZXCEoNrk4lSlKQoI/JlHVcpTKjx9tXD4WfompR68QkibplHAwWK8hN8yxL1Ih
         E74jbIcxiWH4QA33zCKSmbiP7mqxmUKutH/vlIs/HEjzNKLhfVpho/eAeJQ0Qjlwt1gr
         gyI9xMA8TjcXKOiRWjXZWacjETuO12i61h2X5QucSP/lOm9bpX+lV+WqaMHbjZvWzaox
         FDJ/e5GSHx4EX6RlcABrjml8iDbmqjtN94VxVMuOnQhCAMBlDCiZ31AjKG5fXqfwvsmw
         aDAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EIJn9teWUiLNl3ikQxdGr47kMKy7GKhGJibMs59WMAc=;
        b=Q4Qwr8LPDUTHFOQU4Fka+kKVh72gO7WmkxqrzX75NBL0MFDAZqmFN0qozsgjlPmIRj
         /LGcpC2MlS4vuRBRT5ctQAtRn/lVKjf5FP1U0rtRt+LiTibRIDz42sae69hOURDLLoVj
         Ri9kwksKrpDXmu9I/ah6Gk7xJAjJNqTBN3V9m0OIe44XvQvYAMNrnWosARjQnMqvCY6L
         1MD1aMSHEx5abfPO6hK0CB4WhXXrv02PPvso4S41R/FGHtrQBcJ/TaEr1Y4fJ+aDGqq5
         YfNEbEYovc0cQQ6Ah5DiTRJaIs4HmI2VK3EkPN+4NmfoIQbgYl6LdGrj8DYArbM/GoUs
         ahAA==
X-Gm-Message-State: AGi0Pub85onGI/fEPgQmxIgeXIWCUVxgNiq3C22Ui/pcg5ZXuTMWHeKg
        DeO+z9HAkxwwu3bNxIdBDAH1ZVZ1
X-Google-Smtp-Source: APiQypI2harQXVGYEaSvgjJS16uJwWxfnAOOYyG0f4gOVYEL3273owYv+Oo8TMsp5MIys8G0oVVUNg==
X-Received: by 2002:a17:90a:d711:: with SMTP id y17mr70928pju.11.1588611142428;
        Mon, 04 May 2020 09:52:22 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id e5sm9288617pfd.64.2020.05.04.09.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 09:52:21 -0700 (PDT)
Date:   Mon, 4 May 2020 09:52:19 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Joyce Ooi <joyce.ooi@intel.com>
Cc:     Thor Thayer <thor.thayer@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>,
        See Chin Liang <chin.liang.see@intel.com>,
        Dinh Nguyen <dinh.nguyen@intel.com>
Subject: Re: [PATCHv2 08/10] net: eth: altera: add support for ptp and
 timestamping
Message-ID: <20200504165219.GB3481@localhost>
References: <20200504082558.112627-1-joyce.ooi@intel.com>
 <20200504082558.112627-9-joyce.ooi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504082558.112627-9-joyce.ooi@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 04, 2020 at 04:25:56PM +0800, Joyce Ooi wrote:
> From: Dalon Westergreen <dalon.westergreen@intel.com>
> 
> Add support for the ptp clock used with the tse, and update
> the driver to support timestamping when enabled.  We also
> enable debugfs entries for the ptp clock to allow some user
> control and interaction with the ptp clock.
> 
> Cc: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Dalon Westergreen <dalon.westergreen@intel.com>
> Signed-off-by: Joyce Ooi <joyce.ooi@intel.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
