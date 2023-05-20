Return-Path: <netdev+bounces-4064-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85DBB70A62A
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 09:34:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81CC02814C2
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 07:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A39FDA4F;
	Sat, 20 May 2023 07:34:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95ABE624
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 07:34:34 +0000 (UTC)
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD6119F;
	Sat, 20 May 2023 00:34:33 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-64d3578c25bso1609887b3a.3;
        Sat, 20 May 2023 00:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684568073; x=1687160073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wBXlPJ2WOFDTyTHyLQ9M5/vOMvc7Mykf2q4oVdOVeEg=;
        b=QN6XoqWxTSy3GlTXwrZ/aRy5SVogCyExaBhpUYS1aG7Mq5WOb3qX89yDQW8ui6jALU
         bbgFOuA1cNZJjGOuz1NMI+TgiAvv8r+7u4GoJbQ/p40sdOef28WYQn5FJQsFXbtVkGDm
         SX52G9VZgX+PVbKjFyJ7NzW8uysNXhnSRHv/pWPAGBJcV90ve/ITlbXMgbPfhEEehLdS
         yOXFaDq9UrMxxK9Ddi4FhGa3KlEDmLTFJGylHHfigZTp9Vtx6Cdn3h8lgnVfIEHEjfIu
         O/TCrxI/eZzHhH4oqB0CX6HqHyqAINBdChpbtn26Owd3g88VwyG5oE4+njobqdVbxS0v
         3PsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684568073; x=1687160073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wBXlPJ2WOFDTyTHyLQ9M5/vOMvc7Mykf2q4oVdOVeEg=;
        b=HD45ePTKeXE+cSJlRRn1aN1sOsCM7O4cw5X2IVcWgcgtnYe5dQKbFJ5jQFt2uiS2zV
         ryZ7Kieo5VmgFL0F2U3WlACuoUFt2M+tp7/iRrrPcq8k9Brx9PL93rGlvATASUFlln0h
         lKlbnjswGOFMRuRTzlSf/jO58JHjRl8y3yzix26z5V3uEjAa/vvodNRlYlvsyik26hz4
         9vz1iURgU+uBxYpdjjmf4s++d5kRFTW0MThBxnk3cnk17k6HoP1LPfnIb+Qf6BhSbToP
         n1sgLYN20oYABNaiT9E4Z8izOblilCjATGGl5paE7gsRdKyptIGbfpxi2aH5l7dTImWS
         WWDw==
X-Gm-Message-State: AC+VfDzvQiB1adB5Bq4/UmTF0cqq18K/E+JH/80ZXpEvoM0Ql2CBMYbx
	g1YI4IJd6AHsP5T1wCxOZIc=
X-Google-Smtp-Source: ACHHUZ5QxeqwpmX+8bEEsL5MfjtiJ1O/rhGic4E6owcjthl0YEtN976ophiU97AJmOE0F6GQ6X+Lyw==
X-Received: by 2002:a05:6a00:2e87:b0:636:f899:46a0 with SMTP id fd7-20020a056a002e8700b00636f89946a0mr7194401pfb.15.1684568072820;
        Sat, 20 May 2023 00:34:32 -0700 (PDT)
Received: from ubuntu777.domain.name (36-228-97-28.dynamic-ip.hinet.net. [36.228.97.28])
        by smtp.gmail.com with ESMTPSA id fe21-20020a056a002f1500b0064d47cd117esm499146pfb.39.2023.05.20.00.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 May 2023 00:34:32 -0700 (PDT)
From: Min-Hua Chen <minhuadotchen@gmail.com>
To: kuba@kernel.org
Cc: alexandre.torgue@foss.st.com,
	davem@davemloft.net,
	edumazet@google.com,
	joabreu@synopsys.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	mcoquelin.stm32@gmail.com,
	minhuadotchen@gmail.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	peppe.cavallaro@st.com,
	simon.horman@corigine.com
Subject: Re: [PATCH v3] net: stmmac: compare p->des0 and p->des1 with __le32 type values
Date: Sat, 20 May 2023 15:34:28 +0800
Message-Id: <20230520073428.3781-1-minhuadotchen@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230519210439.4a3bb326@kernel.org>
References: <20230519210439.4a3bb326@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Jakub,

>We can make working with sparse easier by making sure it doesn't
>generate false positive warnings :\

It will be good if sparse can handle this case correctly.

>
>> (There are around 7000 sparse warning in ARCH=arm64 defconfig build and
>> sometimes it is hard to remember all the false alarm cases)
>>
>> Could you consider taking this patch, please?
>
>No. We don't take patches to address false positive static
>checker warnings.

No problem.

thanks,
Min-Hua

