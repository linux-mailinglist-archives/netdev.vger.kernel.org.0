Return-Path: <netdev+bounces-2977-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AC92704CC7
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 13:47:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA5CB2815D5
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 11:47:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 689AD24EAB;
	Tue, 16 May 2023 11:47:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B32D34CEB
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 11:47:09 +0000 (UTC)
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6185242
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 04:46:43 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-50bceaf07b8so25487056a12.3
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 04:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684237601; x=1686829601;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=93Yzq0NQPKDWbsmyn4CBhtU/WekigFVvB0zAMgN57XI=;
        b=SUIAwvI++5kAvyMBRhzQ8MviZaRm5/h1Y2uQSZusDH1AIVw9ICmGwylsvUeczZiPZR
         bNaGsvQCvTmWmIyaCN/Rdv08q23K/aF8O1MIle6o8HrqjSsXrAv+rbXKsVDk+CMu2vlA
         tkvSYGP8SY4X+4MZuWafcslj/1QsI4q9Q3qzgkwLH3u+eonbhz5tbQxv2ePF1Ldc28CK
         rK4/j/VsoJrElP+ZbpVWibqAaM50B1PHxWEoVQ+ZtH1FjnAYK0YZDxM7Y1nF+rYb1bbB
         Xr15ZesjVZock5QuYL7A3P5QQfnJwTajoUjJKBEd9Tt8SbIwVb+JnutoK7UjCX1TkBZa
         Nk5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684237601; x=1686829601;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=93Yzq0NQPKDWbsmyn4CBhtU/WekigFVvB0zAMgN57XI=;
        b=jx1n3WwwtPAiacZ/uWr6y7ogCGVLzUoYSttSDoXSroLs+nuGtym3Gks4GI1YmDv/Z7
         ONsHYfHfzd/lLBUDwZVCIgR4JnIi//IpEejSEEC6DC026vvp8YEH3gV38PA9zwJzfhLJ
         yRw9Bao/CFFgnRuQk4f9QKky/7ohhe+YwllVtgQLWAQckMgV933NFELfzSbK4RNkOXCl
         yMA15As6kFyGSwAEpBeYNhlEjLMSRf5w7ZBNnVylOA5JFR6Ccwdz/FNIrbR/Vt+g++SR
         Dm/426z3DT2Y0hqiC+RvVETyL+1TQm6WnU4Dw1EjRLs06hJuhk3GaRBRUcbM+GWw0JTQ
         r05w==
X-Gm-Message-State: AC+VfDwCjatxNfQuCCitpH8HdYVfj8TP/gzxfHYn86VXc+lRthmF6oEr
	E5W8lUL67uB+nmu/9tPruSWF5g==
X-Google-Smtp-Source: ACHHUZ6Le8AKBQWreteycC6kDR3GS8geixujQ/iDzkE/vuc3eDWlUxCWIkF3haHQxfAKxtuwY4i1qA==
X-Received: by 2002:a17:906:58d5:b0:969:9fd0:7cee with SMTP id e21-20020a17090658d500b009699fd07ceemr26824898ejs.10.1684237601227;
        Tue, 16 May 2023 04:46:41 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id qh20-20020a170906ecb400b009655eb8be26sm10862429ejb.73.2023.05.16.04.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 04:46:40 -0700 (PDT)
Date: Tue, 16 May 2023 13:46:39 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc: Vadim Fedorenko <vadfed@meta.com>, Jakub Kicinski <kuba@kernel.org>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"Olech, Milena" <milena.olech@intel.com>,
	"Michalik, Michal" <michal.michalik@intel.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: Re: [RFC PATCH v7 5/8] ice: implement dpll interface to control cgu
Message-ID: <ZGNtH1W3Y/pnx2Hk@nanopsycho>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-6-vadfed@meta.com>
 <ZGJn/tKjzxNYcNKU@nanopsycho>
 <DM6PR11MB46570013B31FCCF1FCE0854D9B799@DM6PR11MB4657.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB46570013B31FCCF1FCE0854D9B799@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Tue, May 16, 2023 at 11:22:37AM CEST, arkadiusz.kubalewski@intel.com wrote:
>>From: Jiri Pirko <jiri@resnulli.us>
>>Sent: Monday, May 15, 2023 7:13 PM
>>
>>Fri, Apr 28, 2023 at 02:20:06AM CEST, vadfed@meta.com wrote:
>>
>>[...]
>>
>>>+static const enum dpll_lock_status
>>>+ice_dpll_status[__DPLL_LOCK_STATUS_MAX] = {
>>>+	[ICE_CGU_STATE_INVALID] = DPLL_LOCK_STATUS_UNSPEC,
>>>+	[ICE_CGU_STATE_FREERUN] = DPLL_LOCK_STATUS_UNLOCKED,
>>>+	[ICE_CGU_STATE_LOCKED] = DPLL_LOCK_STATUS_CALIBRATING,
>>
>>This is a bit confusing to me. You are locked, yet you report
>>calibrating? Wouldn't it be better to have:
>>DPLL_LOCK_STATUS_LOCKED
>>DPLL_LOCK_STATUS_LOCKED_HO_ACQ
>>
>>?
>>
>
>Sure makes sense, will add this state.

Do you need "calibrating" then? I mean, the docs says:
  ``LOCK_STATUS_CALIBRATING``   dpll device calibrates to lock to the
                                source pin signal

Yet you do: [ICE_CGU_STATE_LOCKED] = DPLL_LOCK_STATUS_CALIBRATING
Seems like you should have:
[ICE_CGU_STATE_LOCKED] = DPLL_LOCK_STATUS_LOCKED
[ICE_CGU_STATE_LOCKED_HO_ACQ] = DPLL_LOCK_STATUS_LOCKED_HO_ACQ,

and remove DPLL_LOCK_STATUS_CALIBRATING as it would be unused?

Also, as a sidenote, could you use the whole names of enum value names
in documentation? Simple reason, greppability.

Thanks!


>
>>
>>>+	[ICE_CGU_STATE_LOCKED_HO_ACQ] = DPLL_LOCK_STATUS_LOCKED,
>>>+	[ICE_CGU_STATE_HOLDOVER] = DPLL_LOCK_STATUS_HOLDOVER,
>>>+};
>>
>>[...]

