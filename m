Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6DC29B8C
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 17:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390078AbfEXPyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 11:54:51 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42179 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389385AbfEXPyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 11:54:51 -0400
Received: by mail-pg1-f195.google.com with SMTP id 33so2318655pgv.9
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 08:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Du6w+2+UwkIHK2brKA6JhoLuk0pTb3k2YkJQ9QkXb5A=;
        b=NPmwV3ekPVZbO6/8WqEKFArCsiFuvQGeD///Ez+NHm+WfNHaFUPgI/BIeFtin3ovdq
         ue3qX1Lsf1AYT6isTJgOeENFhj2y8sE4LCN1MSvd7AAt1Go6uDtZYbY7VIjKFfhrTOSV
         kR0n57fI6cJ1daYyzWhNnt6c3lv1uw960NdXDkj5jDuO7yBUNbTJO9mNfYsUmALCLgpM
         Wmo13sE7VtC8y1KBgD588Ypkzyh4Efd1qhYLFloatzCy66hrNQAgcps2PsX9F4LXgdrk
         /Moyy+IWLyDkHsYd8t5GcQEVjo9sLlF+7y4T4Okrywf74vmMMNyHNVlCOPXx1adCXnf1
         WpQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Du6w+2+UwkIHK2brKA6JhoLuk0pTb3k2YkJQ9QkXb5A=;
        b=nKWbnYS/XxSOeAvgqpOjQek1P4Q1/PkERcuw6421TfpHV52vbS+gc8JcEcjm53vS5Z
         0ueUqCQV2OZaMqVtscUqY3zCKsiBiJxllMAMURPEwGJI4t0BwwIIG/o94GR544DnSfQ3
         iQVuuen/2osbdPgy+0fw6r/TVDq1ZAVnH5U6scZ3RfBdwkeedl/rHAahhyhLlHBoYdfe
         Qhsga9PHENeIjuumk6C81/KkO7cn7JHFEgU2lAiJOwgvCq6laDyvQKFxz33S1MySS/jA
         9PvYB+XLcNTc+nN1NVz5Ztiu3WnsI+/seEOYg3cgzla1PNE2JUbnLNbts6Kywq+UNL2n
         hUqQ==
X-Gm-Message-State: APjAAAX7xA2awpzqrNfbgjDCRZ+1I4+gW0gKv/TlbCoOssKXgPwqTEBl
        QJtyxiMo9wKf+1FM91lGTrkdhg==
X-Google-Smtp-Source: APXvYqxOnx7mCpybBwIQLMIoTgyOqN50R65DuhSdi/KxRXZwOTSyD/NPq3t0AAgoI4Izp3Wto/Xpcw==
X-Received: by 2002:a63:5105:: with SMTP id f5mr90031594pgb.373.1558713290466;
        Fri, 24 May 2019 08:54:50 -0700 (PDT)
Received: from cakuba.netronome.com ([2601:646:8e00:e50::2])
        by smtp.gmail.com with ESMTPSA id n1sm2422834pgv.15.2019.05.24.08.54.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 24 May 2019 08:54:50 -0700 (PDT)
Date:   Fri, 24 May 2019 08:54:46 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, mlxsw@mellanox.com, sthemmin@microsoft.com,
        saeedm@mellanox.com, leon@kernel.org
Subject: Re: [patch net-next 3/7] mlxfw: Propagate error messages through
 extack
Message-ID: <20190524085446.59dc6f2f@cakuba.netronome.com>
In-Reply-To: <20190524081110.GB2904@nanopsycho>
References: <20190523094510.2317-1-jiri@resnulli.us>
        <20190523094510.2317-4-jiri@resnulli.us>
        <7f3362de-baaf-99ee-1b53-55675aaf00fe@gmail.com>
        <20190524081110.GB2904@nanopsycho>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 May 2019 10:11:10 +0200, Jiri Pirko wrote:
> Thu, May 23, 2019 at 05:19:46PM CEST, dsahern@gmail.com wrote:
> >On 5/23/19 3:45 AM, Jiri Pirko wrote:  
> >> @@ -57,11 +58,13 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
> >>  	if (fsm_state_err != MLXFW_FSM_STATE_ERR_OK) {
> >>  		pr_err("Firmware flash failed: %s\n",
> >>  		       mlxfw_fsm_state_err_str[fsm_state_err]);
> >> +		NL_SET_ERR_MSG_MOD(extack, "Firmware flash failed");
> >>  		return -EINVAL;
> >>  	}
> >>  	if (curr_fsm_state != fsm_state) {
> >>  		if (--times == 0) {
> >>  			pr_err("Timeout reached on FSM state change");
> >> +			NL_SET_ERR_MSG_MOD(extack, "Timeout reached on FSM state change");  
> >
> >FSM? Is the meaning obvious to users?  
> 
> It is specific to mlx drivers.

What does it stand for?  Isn't it just Finite State Machine?
