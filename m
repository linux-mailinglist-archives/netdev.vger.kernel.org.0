Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB9ED17A0AF
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 08:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgCEHty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 02:49:54 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35540 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgCEHtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 02:49:53 -0500
Received: by mail-wm1-f67.google.com with SMTP id m3so4584137wmi.0
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 23:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MuhKBstMDYyGoLurHhRL21iXPco86nOkGpRlC4a8Yfw=;
        b=ZmGXXByxvAJQk9xFadqh2RQpql2sw/UZDi+UevOYWXXdiZNgrY7T2HFj0OFvgCHVNQ
         i1VlrtlItEGG89z7IUPxH5EXoxVwnmFmjui5CoiUAcdIeNXcrxs0OhSFIEv1rS4WsSu9
         /0v9eSG9ZyTsIxND7WZbvUPmSsSZELV8tEMlFbzstFrEnzsUpGLtWMvb0+hRkLgyOXmf
         BDup8WY4pzCCsBLATwKf13REJhLNed2Fv/8qDb1Y7rx/qsh45CtcxQD8tOy6g8QpkZQ4
         FOc1QGrOixsRje7iASuN8T7eZDpioPQYmfrLvDGWyZeEqG2Q5IHolLPJRFvslNLV6qjw
         LQiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MuhKBstMDYyGoLurHhRL21iXPco86nOkGpRlC4a8Yfw=;
        b=YaGqA9OBSPWHvvPlB4LOJcV54NqSXoFirJvErAPfSgRwlcB8ZfaLEqjwvwSEayQCCY
         m6AiazPJ5tsLed3FOBQJ497DOcahD57mO4LccVWzyTSXcLJcvnmQKcyk3XmnGaS4glPP
         QkRXSH42jidC1Kq8yzzGaNHWSIUtDcp7uc2rcrBjYYIOxVKJAQPjfjwHQ3o8PdbNF6Fk
         5G/vNgNdY9Rjk3QCj2UevX7VoAb4KL4Jjtg3ir//q+FkhusqQtWeMdMB+hCqP65/vRuM
         id2UKaJ1oEENAY/Azxb15vDur74Je8jKbZYXqOctBpB3VCEFHE5i0/E0N+fs9a08UUme
         +qEw==
X-Gm-Message-State: ANhLgQ2IaxItbibA15kc3TdQLjnAfRvFM0vSOPONko2zb13bNiHcBETY
        glcPO1bdXhnYMf/fK5Ex6Jly2g==
X-Google-Smtp-Source: ADFU+vuH9cccos/pj3oJnmiuh1+4ygAOOUM1ue7igBIRwdKyVyIjwxhZgaI4MHTsn0RXPOed67TT/Q==
X-Received: by 2002:a7b:c939:: with SMTP id h25mr7977432wml.106.1583394591873;
        Wed, 04 Mar 2020 23:49:51 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id z12sm6531206wrl.48.2020.03.04.23.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 23:49:51 -0800 (PST)
Date:   Thu, 5 Mar 2020 08:49:50 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, petrm@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 1/5] net: sched: Make FIFO Qdisc offloadable
Message-ID: <20200305074950.GA2190@nanopsycho>
References: <20200305071644.117264-1-idosch@idosch.org>
 <20200305071644.117264-2-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305071644.117264-2-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 05, 2020 at 08:16:40AM CET, idosch@idosch.org wrote:
>From: Petr Machata <petrm@mellanox.com>
>
>Invoke ndo_setup_tc() as appropriate to signal init / replacement,
>destroying and dumping of pFIFO / bFIFO Qdisc.
>
>A lot of the FIFO logic is used for pFIFO_head_drop as well, but that's a
>semantically very different Qdisc that isn't really in the same boat as
>pFIFO / bFIFO. Split some of the functions to keep the Qdisc intact.
>
>Signed-off-by: Petr Machata <petrm@mellanox.com>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
