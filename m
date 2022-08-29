Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D245A4297
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 07:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiH2FuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 01:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiH2FuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 01:50:05 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6579213F26;
        Sun, 28 Aug 2022 22:50:04 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id b9so5343196qka.2;
        Sun, 28 Aug 2022 22:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=zkDe2fzQ9fEV4RqEIAa8ZUKyTere+0TLjVrnWosBhRQ=;
        b=aOW7Y4CbPGtc6IgJZvMrZn3xcKjgGn4VhZsRtd1KFi3sBjd1hCxJ93Z40GJ1tRRMCm
         keCqRDoYP7q+JQslnKgTaZ4GoipL9iILi4+yrWjOM84RmS7o0UBxDimEGV4y4evSN0TX
         c/P9AY8thKfolw7bDmMkQGCDKuIr3M9FTW8sbKFfOFmOo/WfSeRaiWFnCWEaRej+wGId
         X3tAbWU4DRvyPqfwQ803n+8AJ6lHArOecOW3hT66u6l3tZS2R+yYx3AL+GPOMG3GFNWi
         l0BIRD4KARAe8uh66EIr5mFSRoIJEV5iEjsMfDk1THUOwmFGQx9PAFInC28B26QpCYoB
         DZKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=zkDe2fzQ9fEV4RqEIAa8ZUKyTere+0TLjVrnWosBhRQ=;
        b=c2dQkDOz4PsAH+y0Xj74cHz8tze4/6S33yM5VdMfO6AZpg0CYqKdYvGUTLcmNlg04i
         DTKEFhg+bgw+RodZ/ak7zU3k70KuzrFTbjBxe1d1wjIAyYdFccDPLIPL60YYMZbjs62x
         SgO7Cun0q9B4dgaLt8g1ySkgG0dscDFNctWOQBa2/QYzWi/L49Zb00ob9MtYjfoVLyRb
         5skQd3WS+0RLTApeGUY0lszUFu/NAMp8kAPyg8jKEKcbXJVfV/k3j892lz/VKGKZyszY
         VQRCLYFWfRnG9AcKjYeg/kbHnNqME0UE5CilTNCrGYLlpgF1hbQGX154Fy6XJp6ELL+e
         0UnA==
X-Gm-Message-State: ACgBeo3ibAEoTCQ0u/IqP4RidfX+sYVgU15mi4BKImTHMFx+g4etJMRl
        FFn5ADe+ZKjW3SJsK011D8U=
X-Google-Smtp-Source: AA6agR4DMfIHHFLozo4VOWYncXwROqclALGVpkca9iCXjcvKb5eACoAVsr7k552lI/ZnrZ4y+nVmwQ==
X-Received: by 2002:a05:620a:573:b0:6bb:2865:e3cc with SMTP id p19-20020a05620a057300b006bb2865e3ccmr7468670qkp.15.1661752203552;
        Sun, 28 Aug 2022 22:50:03 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:5e78:4de7:b681:c052])
        by smtp.gmail.com with ESMTPSA id v38-20020a05622a18a600b0031ef0081d77sm4751644qtc.79.2022.08.28.22.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Aug 2022 22:50:02 -0700 (PDT)
Date:   Sun, 28 Aug 2022 22:50:01 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, jiri@resnulli.us,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH net-next] net: sched: using TCQ_MIN_PRIO_BANDS in
 prio_tune()
Message-ID: <YwxTiZ7tfMaaDBBM@pop-os.localdomain>
References: <20220826041035.80129-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826041035.80129-1-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 12:10:35PM +0800, Zhengchao Shao wrote:
> Using TCQ_MIN_PRIO_BANDS instead of magic number in prio_tune().
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks.
