Return-Path: <netdev+bounces-4954-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11FD170F5BB
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:57:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F3A0281297
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:57:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C95F17AC3;
	Wed, 24 May 2023 11:57:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE6717ABB
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 11:57:23 +0000 (UTC)
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D65F189
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 04:57:21 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-96ff9c0a103so118244966b.0
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 04:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684929439; x=1687521439;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8xGgwhZuwNeqYxH9L83Q934ma2e+0jydNm96/qWLjL4=;
        b=XJz3HePau496fwN2NE1f2BhihcSfREvCJHyT1J2m6Ds++Lb/otaebLwm7oSG9UQ1uR
         95PgO6+D/v48gWzGRZ0DuTNq7WDneI4cIviBavFfe9sVuXeN2jlFOgrkCj7O+9FqnFfW
         vwXStLpTJbGZMNz4VPDu+QEdjw1NT68rV1BYULR9nYNlIgctzVWAC2rJ6nN5SKQc8IEu
         d49JeJGaJA1dD3TC0juqFOjifEQsuiRguYZnvjJAbPcq1JIQTndxjiGeWYtdLrmZUcgM
         uKVb/k8jWn8Pg/TH7/zwVzKJTFnFGtuAWMreab0xauMBFrIp9s5ZjGbw2mz5uXw4A8wc
         BEng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684929439; x=1687521439;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8xGgwhZuwNeqYxH9L83Q934ma2e+0jydNm96/qWLjL4=;
        b=ktOFIScOFRvXQxqdQA6JsHp+apj+0jDrUt+sYrtpz98R5hJhr+TT3vncUNcSUxXXkh
         5uQgmxCg0rlQQ14PM7hSkdokS2M3RWSGCDYx17wmijAiD9ph5tZuWetJp1LFUQ6thaAr
         t1MOfVdTpP3O1dP1td/73TB3AJrw2gXIAU0iRgjtsAHlLGxQZW00ph/UtrtwyQ+9RcKr
         WtJH6abNR2E1uiiguAcZUsBtva9Ie6HCW5/zxZcbng5HVN3pORxgRopd7BFKZvVRf2JM
         BEYwx+xSj68vHFLk7dQkRGf2Jg590iHFC/bf+wbmw7QtpnrwFo5sELXU1tJry6YLAlK9
         D47Q==
X-Gm-Message-State: AC+VfDwtiX9CZIVHRn9KM63eiQGCtI5E4ftebwVXf1kX5WRf2JtFQott
	nQGpgHFlQvellaamS0qeZiLljQ==
X-Google-Smtp-Source: ACHHUZ7VnKKBZdozxZSF+zVrtbQzYv2d5h4F+x2QUBVt9vOncN1/e/5dZQTZcl9sFFgswAhZqXmV2g==
X-Received: by 2002:a17:906:190b:b0:96a:3852:61e7 with SMTP id a11-20020a170906190b00b0096a385261e7mr15098805eje.77.1684929439515;
        Wed, 24 May 2023 04:57:19 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id w20-20020a170907271400b0096a16761ab4sm5788323ejk.144.2023.05.24.04.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 04:57:18 -0700 (PDT)
Date: Wed, 24 May 2023 13:57:18 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, netdev@vger.kernel.org,
	Lukasz Czapnik <lukasz.czapnik@intel.com>,
	przemyslaw.kitszel@intel.com,
	Michal Wilczynski <michal.wilczynski@intel.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: Re: [PATCH net-next 4/5] ice: Add txbalancing devlink param
Message-ID: <ZG37nuqjiZdjQADm@nanopsycho>
References: <20230523174008.3585300-1-anthony.l.nguyen@intel.com>
 <20230523174008.3585300-5-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523174008.3585300-5-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Tue, May 23, 2023 at 07:40:07PM CEST, anthony.l.nguyen@intel.com wrote:
>From: Lukasz Czapnik <lukasz.czapnik@intel.com>
>
>It was observed that Tx performance was inconsistent across all queues
>and/or VSIs and that it was directly connected to existing 9-layer
>topology of the Tx scheduler.
>
>Introduce new private devlink param - txbalance. This parameter gives user
>flexibility to choose the 5-layer transmit scheduler topology which helps
>to smooth out the transmit performance.
>
>Allowed parameter values are true for enabled and false for disabled.
>
>Example usage:
>
>Show:
>devlink dev param show pci/0000:4b:00.0 name txbalancing
>pci/0000:4b:00.0:
>  name txbalancing type driver-specific
>    values:
>      cmode permanent value true

"TXbalancing" sounds quite generic. Also, TXbalancing==false might sound
there is no tx balancing. That is confusing.


