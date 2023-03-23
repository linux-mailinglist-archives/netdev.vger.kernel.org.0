Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1166C6EC2
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 18:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbjCWRZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 13:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbjCWRZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 13:25:11 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510B719C7B
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 10:25:09 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id l27so13116897wrb.2
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 10:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google; t=1679592308;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ibZehAMU95QClUuNoAJiAG9Xi+jaU1H+meb4jOWGkvI=;
        b=AQmsj3kxE5fcbMyPL49KBLJiR9dS/o8sI/0QCe9HwVJD0JitvR2v2bbXRolFAaz9hp
         zWWx0yLcYfgAlpAxaJ0jUY2kia2UQ/X/HFF5JzceuF/aEEmbr2g3rlW6U4nAB4uGl7Lu
         rUGLQWZtiAQ/j/EgPPcYZIuzwZwPmBs/cSJcU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679592308;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ibZehAMU95QClUuNoAJiAG9Xi+jaU1H+meb4jOWGkvI=;
        b=kMnCprel7vJyULPc/zr66InFOaQVgxqg6Mi9ezpyJ6NYOgz/2I8GjeyOrQuRPg8Yt9
         oNuoSGmpG3RZjaQBNbOmnY7CpqiLm8dAkCLki9mzidOjy2UQ1utehL7Til7MjEy7Dx0Q
         WEr94zJEg0QkUgi31lb1j4DcSOEvpsGT/KALLCNXwhrJKmK7wUJPhs0c3wVraU4X3k00
         go2nE92gDL4bIW9wTTYbjSKgZalBxGK21Q8xrnUT+cZ0lv86FpkrbGQYR5q9580s2c7O
         aiuMOQqrRu4clkhtoN3bjQydw/5kZMxTCoNkIKyoVjqH6e2u/DjrI8rbuUArdj9W9sn+
         V5Lg==
X-Gm-Message-State: AAQBX9dzRUTDTXI8SY03xB3ZJ5lDmpnc3OGvL7XgHWRfHfkCv9NK7dPT
        oEp88VhIecHB7uyFwF+BH04GphdnF3y34tKi6lKVGQ==
X-Google-Smtp-Source: AKy350auvmdyBglcTfV86qYfWUmp7zJ4yneypHrnpQYCgYYkY1qt4i6NnbUZrQQy/EJj4CrUmqewHs30B0Bkh6nQLtA=
X-Received: by 2002:a5d:48c9:0:b0:2d5:bc78:15f3 with SMTP id
 p9-20020a5d48c9000000b002d5bc7815f3mr795212wrs.10.1679592307818; Thu, 23 Mar
 2023 10:25:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230323090314.22431-1-cai.huoqing@linux.dev> <20230323090314.22431-4-cai.huoqing@linux.dev>
In-Reply-To: <20230323090314.22431-4-cai.huoqing@linux.dev>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Thu, 23 Mar 2023 10:24:55 -0700
Message-ID: <CAOkoqZk0GRRZb5PyZdQ8THK+oZ+b9PKYUR8jRf2f2e8imEPaGQ@mail.gmail.com>
Subject: Re: [PATCH 4/8] net/fungible: Remove redundant pci_clear_master
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Dariusz Marcinkiewicz <reksio@newterm.pl>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Shannon Nelson <shannon.nelson@amd.com>,
        Brett Creeley <brett.creeley@amd.com>, drivers@pensando.io,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jian Shen <shenjian15@huawei.com>, Hao Lan <lanhao@huawei.com>,
        Jie Wang <wangjie125@huawei.com>,
        Long Li <longli@microsoft.com>, Jiri Pirko <jiri@resnulli.us>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 2:04=E2=80=AFAM Cai Huoqing <cai.huoqing@linux.dev>=
 wrote:
>
> Remove pci_clear_master to simplify the code,
> the bus-mastering is also cleared in do_pci_disable_device,
> like this:
> ./drivers/pci/pci.c:2197
> static void do_pci_disable_device(struct pci_dev *dev)
> {
>         u16 pci_command;
>
>         pci_read_config_word(dev, PCI_COMMAND, &pci_command);
>         if (pci_command & PCI_COMMAND_MASTER) {
>                 pci_command &=3D ~PCI_COMMAND_MASTER;
>                 pci_write_config_word(dev, PCI_COMMAND, pci_command);
>         }
>
>         pcibios_disable_device(dev);
> }.
> And dev->is_busmaster is set to 0 in pci_disable_device.
>
> Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>

Acked-by: Dimitris Michailidis <dmichail@fungible.com>


> ---
>  drivers/net/ethernet/fungible/funcore/fun_dev.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/fungible/funcore/fun_dev.c b/drivers/ne=
t/ethernet/fungible/funcore/fun_dev.c
> index 3680f83feba2..a7fbd4cd560a 100644
> --- a/drivers/net/ethernet/fungible/funcore/fun_dev.c
> +++ b/drivers/net/ethernet/fungible/funcore/fun_dev.c
> @@ -746,7 +746,6 @@ void fun_dev_disable(struct fun_dev *fdev)
>         bitmap_free(fdev->irq_map);
>         pci_free_irq_vectors(pdev);
>
> -       pci_clear_master(pdev);
>         pci_disable_device(pdev);
>
>         fun_unmap_bars(fdev);
> @@ -821,7 +820,6 @@ int fun_dev_enable(struct fun_dev *fdev, struct pci_d=
ev *pdev,
>  disable_admin:
>         fun_disable_admin_queue(fdev);
>  free_irq_mgr:
> -       pci_clear_master(pdev);
>         bitmap_free(fdev->irq_map);
>  free_irqs:
>         pci_free_irq_vectors(pdev);
> --
> 2.34.1
>
