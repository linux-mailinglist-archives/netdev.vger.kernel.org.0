Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370545B2E60
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 07:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiIIF7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 01:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIIF7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 01:59:36 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8C213E13;
        Thu,  8 Sep 2022 22:59:33 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id m15so931825lfl.9;
        Thu, 08 Sep 2022 22:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=GwEzI0kO4RfN5VRRjI+LE8P7tXiZTrFPjzX63q640wQ=;
        b=Ph2dJocVfu7cZCY74HPPZlmd8bTxu10YvyVfCNPq/GCd2dBg1r4n5HAOREcaTe3GMA
         nYKbrLxlN7YZeOwhQT1HzsXxjzhwxfcnCwCf7DwhwexFIUpWtGBjpIO88nTZJ7GFnxnO
         ZgSgLg9u+4RoGudchzNv9xQPdEMXZ7EdOeunbNUF0ZFSTxa/Dd2OuGU8rRwHelvORHe3
         XGUFqIOzH8wtENFZ34FBh7L8W9cjLpQXoyoIO67a0AbrUrTTCj5IPHUCuKEqKQbnU+X0
         trXVuMfGr55+WYQ3Vfy1Ob1jkJgGbyRKP1yFGYiAmsAIvfi7OutNrmQkcBr1KNQi2NLG
         WBRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=GwEzI0kO4RfN5VRRjI+LE8P7tXiZTrFPjzX63q640wQ=;
        b=UwNPCMDD0njpq+tI9Sj4s6TLpF/RqJC/zXEwjBzA5FANs8VOGkYw8k5GWgy/O/5lK/
         OOvdceAhsLkbsYrczBpMCyFMj23X9XgjTqDC+e++P9hCkWSW9jlpddoqj2vgfuYWPS9w
         jd4PcVf6hND2wfDoCXyDI4yjoCj4dPpRT+MFs7kUrEc+/qKk3e+3PJCt3Ixl4s1iu0dz
         RMrMZCpx7DblvNPe4Qgi4HThrI39N5TKWaIHC9giYTAPlDtSFxt4gzkhqZELjRmXyMqi
         hbhMQcUs7VkBbTcf9EM3mvijOQvmUeEawkFlPDTSWujAixCbFTFIITCwpAkCgP7jbdJs
         ZEBA==
X-Gm-Message-State: ACgBeo32jDOaOwV+yvzjMscf6/q9n0XSfZwqMTR4ZQUcV9fsoiVMOrRk
        oB4nwEfBtUEQM5la73iaCe0=
X-Google-Smtp-Source: AA6agR6yNF7EskTL51ovmHGraZlE8pE/Hc4/xVbGT+0yH7C40goRUQ+C5UmhNoOhTK+6EjjbxPeBQw==
X-Received: by 2002:a05:6512:3a95:b0:498:f272:6587 with SMTP id q21-20020a0565123a9500b00498f2726587mr1537763lfu.148.1662703171985;
        Thu, 08 Sep 2022 22:59:31 -0700 (PDT)
Received: from home.paul.comp (paulfertser.info. [2001:470:26:54b:226:9eff:fe70:80c2])
        by smtp.gmail.com with ESMTPSA id r15-20020ac24d0f000000b00494a2a0f6cfsm129475lfi.183.2022.09.08.22.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 22:59:31 -0700 (PDT)
Received: from home.paul.comp (home.paul.comp [IPv6:0:0:0:0:0:0:0:1])
        by home.paul.comp (8.15.2/8.15.2/Debian-22) with ESMTP id 2895xRB0020092;
        Fri, 9 Sep 2022 08:59:29 +0300
Received: (from paul@localhost)
        by home.paul.comp (8.15.2/8.15.2/Submit) id 2895xPve020091;
        Fri, 9 Sep 2022 08:59:25 +0300
Date:   Fri, 9 Sep 2022 08:59:25 +0300
From:   Paul Fertser <fercerpav@gmail.com>
To:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        openbmc@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ncsi: Add Intel OS2BMC OEM command
Message-ID: <YxrWPfErV7tKRjyQ@home.paul.comp>
References: <20220909025716.2610386-1-jiaqing.zhao@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909025716.2610386-1-jiaqing.zhao@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, Sep 09, 2022 at 10:57:17AM +0800, Jiaqing Zhao wrote:
> The Intel OS2BMC OEM NCSI command is used for controlling whether
> network traffic between host and sideband is allowed or not. By
> default such traffic is disallowed, meaning that if the device using
> NCS (usually BMC) does not have extra active connection, it cannot
> reach the host.

Can you please explain the rationale behind introducing this as a
compile-time kernel config option? I can probably imagine how this can
make sense as a DT switch (e.g. to describe hardware where there's no
other communication channel between the host and BMC) but even this
feels far-fetched.

Can you please outline some particular use cases for this feature?

-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav@gmail.com
