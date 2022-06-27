Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEA655CAAE
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238836AbiF0RUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 13:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236151AbiF0RUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 13:20:01 -0400
Received: from mx0b-00256a01.pphosted.com (mx0b-00256a01.pphosted.com [67.231.153.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7274D20A
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 10:20:00 -0700 (PDT)
Received: from pps.filterd (m0119691.ppops.net [127.0.0.1])
        by mx0b-00256a01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25RFVnD9034860
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 13:19:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nyu.edu; h=mime-version :
 references : in-reply-to : from : date : message-id : subject : to : cc :
 content-type; s=20180315; bh=8YDueYU8b2jg9KPKbFHwrWNJX+YOLcGyJVjwU50A1Eo=;
 b=JWjQ377n+MxBhm+OC1LZmsvp5c9zHbBCrZnhy4chUwctJhQgf9s7oeWS2pt/0PvNuorp
 P3GhivAhKvg1oBfLsamcWvL0bL6P3xSOTr2jOA7Gw9rMnmNeIKBmSrzBzyXNX461Xk2s
 k7HdIPuKjWyRxfrwGlssd2F48HjDZgP+qyOigDDuPdAXPeMVbFneGCqxMUtNNnwET5NW
 PkDKi+ZEz+8KNpw8c8PhtNizTCo/dEyL5q7zQDYgBnuYKc34u0avTt+dsnsOA7uo/cYX
 8AOSHXlLVLhHPZ8DEuYXONp3NM99rcrmThSQE7hif48+xxbtS29tG9FL+Qs2dtQG6NOg RQ== 
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
        by mx0b-00256a01.pphosted.com (PPS) with ESMTPS id 3gyf95j9js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 13:19:59 -0400
Received: by mail-ej1-f69.google.com with SMTP id qf29-20020a1709077f1d00b00722e68806c4so2656251ejc.4
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 10:19:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8YDueYU8b2jg9KPKbFHwrWNJX+YOLcGyJVjwU50A1Eo=;
        b=rRvBWMXAIlJqAnKJGln8bFVAbQmK2Gvj/SdRUe7ArDY2gezFYy3tlFz8hlaejAW5mh
         +uVhCHE79B31sF+L61/lZy/sbLsRy2T3Y0zdjTo3VpGssVMz6Iwd3TKK0G1fxKx1FI9V
         Gmkp7p9t2w/b5axX0RG0QGMutGtJPSa0M5pb6wy3+iUMzvr/rXJc5MbwjYzLtED6y1jl
         3oc7P2nNPzkU1l4BVcFTiE3bBCX1xWqWOkt0kHrkKkEaW2XSp1+FFlFcvhWSDOaXsW3C
         3WyS9ZbI+1Cx+P6d+nf2vxcMzHIatF8ehRm6WjyrKG0lWdhA7H6IlGWR67g3XiVC693g
         ZDsQ==
X-Gm-Message-State: AJIora+Du0g0uUkKQHedTeEfS7HKgMqscx6OZAZgtsE8sTWzsC533Aq+
        eGFiyKXyCyQH0O8Gi8/tk+3g8WdmWe8URCPk/nly6ACeDFrn6KNe1JxGZ8bAxAejY2oDdzdwY7T
        01B0mginqB8xpXR/WZ/fjsPH4C1+n7rA=
X-Received: by 2002:a17:907:3e81:b0:726:9615:d14d with SMTP id hs1-20020a1709073e8100b007269615d14dmr9595604ejc.517.1656350396643;
        Mon, 27 Jun 2022 10:19:56 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vSQ5/1QB71Hg4lzY2NR2sSKZpWJgM46OeZOkRdEbMiJUX0n0Hl5pbzy0UCEvEDqcgezp0Hb7qhSaXUoeuvbR8=
X-Received: by 2002:a17:907:3e81:b0:726:9615:d14d with SMTP id
 hs1-20020a1709073e8100b007269615d14dmr9595584ejc.517.1656350396337; Mon, 27
 Jun 2022 10:19:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220617050101.37620-1-huzh@nyu.edu> <202206280043.B60ScXNe-lkp@intel.com>
In-Reply-To: <202206280043.B60ScXNe-lkp@intel.com>
From:   Zhenghao Hu <huzh@nyu.edu>
Date:   Mon, 27 Jun 2022 13:19:44 -0400
Message-ID: <CANeN5i-jh3-O+foQztariey1hWv5mwgpdrDiZzkFTRoVh-s9BA@mail.gmail.com>
Subject: Re: [PATCH v2] Fix buffer overflow in hinic_devlink.c:hinic_flash_fw
To:     kernel test robot <lkp@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-ORIG-GUID: TM3cFYkaH7hscAQh5UdrzLNvhejo8SC-
X-Proofpoint-GUID: TM3cFYkaH7hscAQh5UdrzLNvhejo8SC-
X-Orig-IP: 209.85.218.69
X-Proofpoint-Spam-Details: rule=outbound_bp_notspam policy=outbound_bp score=0 clxscore=1015
 mlxscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206270071
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ugh... please ignore this patch. I got it mixed up with the fortified
string warning from the other memcpy in the same file.


On Mon, Jun 27, 2022 at 12:15 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi HighW4y2H3ll,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on horms-ipvs/master]
> [also build test WARNING on linus/master]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://urldefense.com/v3/__https://git-scm.com/docs/git-format-patch__;!!BhJSzQqDqA!XYG2GtvZ6S2jfkp5Dd1G9i6xPhuBkvMuQWVEjV_rgLnKYvLVmow_TtmG3s5MYZMUQaWO1co$ ]
>
> url:    https://urldefense.com/v3/__https://github.com/intel-lab-lkp/linux/commits/HighW4y2H3ll/Fix-buffer-overflow-in-hinic_devlink-c-hinic_flash_fw/20220617-130659__;!!BhJSzQqDqA!XYG2GtvZ6S2jfkp5Dd1G9i6xPhuBkvMuQWVEjV_rgLnKYvLVmow_TtmG3s5MYZMUe5-_sY0$
> base:   https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs.git__;!!BhJSzQqDqA!XYG2GtvZ6S2jfkp5Dd1G9i6xPhuBkvMuQWVEjV_rgLnKYvLVmow_TtmG3s5MYZMUf3RrLGs$  master
> config: arm64-randconfig-r022-20220627 (https://urldefense.com/v3/__https://download.01.org/0day-ci/archive/20220628/202206280043.B60ScXNe-lkp@intel.com/config__;!!BhJSzQqDqA!XYG2GtvZ6S2jfkp5Dd1G9i6xPhuBkvMuQWVEjV_rgLnKYvLVmow_TtmG3s5MYZMU2ridR0A$ )
> compiler: aarch64-linux-gcc (GCC) 11.3.0
> reproduce (this is a W=1 build):
>         wget https://urldefense.com/v3/__https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross__;!!BhJSzQqDqA!XYG2GtvZ6S2jfkp5Dd1G9i6xPhuBkvMuQWVEjV_rgLnKYvLVmow_TtmG3s5MYZMUmop686I$  -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://urldefense.com/v3/__https://github.com/intel-lab-lkp/linux/commit/821efd063fed15fd0bab30b29df0af61d5ba4cac__;!!BhJSzQqDqA!XYG2GtvZ6S2jfkp5Dd1G9i6xPhuBkvMuQWVEjV_rgLnKYvLVmow_TtmG3s5MYZMU2ZVzELE$
>         git remote add linux-review https://urldefense.com/v3/__https://github.com/intel-lab-lkp/linux__;!!BhJSzQqDqA!XYG2GtvZ6S2jfkp5Dd1G9i6xPhuBkvMuQWVEjV_rgLnKYvLVmow_TtmG3s5MYZMU6rLGMIs$
>         git fetch --no-tags linux-review HighW4y2H3ll/Fix-buffer-overflow-in-hinic_devlink-c-hinic_flash_fw/20220617-130659
>         git checkout 821efd063fed15fd0bab30b29df0af61d5ba4cac
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash drivers/net/ethernet/huawei/hinic/
>
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>    drivers/net/ethernet/huawei/hinic/hinic_devlink.c: In function 'hinic_flash_fw':
> >> drivers/net/ethernet/huawei/hinic/hinic_devlink.c:176:25: warning: 'memset' used with length equal to number of elements without multiplication by element size [-Wmemset-elt-size]
>      176 |                         memset(fw_update_msg->data, 0, MAX_FW_FRAGMENT_LEN);
>          |                         ^~~~~~
>
>
> vim +/memset +176 drivers/net/ethernet/huawei/hinic/hinic_devlink.c
>
> 5e126e7c4e5275 Luo bin 2020-07-15  123
> 5e126e7c4e5275 Luo bin 2020-07-15  124  static int hinic_flash_fw(struct hinic_devlink_priv *priv, const u8 *data,
> 5e126e7c4e5275 Luo bin 2020-07-15  125                            struct host_image_st *host_image)
> 5e126e7c4e5275 Luo bin 2020-07-15  126  {
> 5e126e7c4e5275 Luo bin 2020-07-15  127          u32 section_remain_send_len, send_fragment_len, send_pos, up_total_len;
> 5e126e7c4e5275 Luo bin 2020-07-15  128          struct hinic_cmd_update_fw *fw_update_msg = NULL;
> 5e126e7c4e5275 Luo bin 2020-07-15  129          u32 section_type, section_crc, section_version;
> 5e126e7c4e5275 Luo bin 2020-07-15  130          u32 i, len, section_len, section_offset;
> 5e126e7c4e5275 Luo bin 2020-07-15  131          u16 out_size = sizeof(*fw_update_msg);
> 5e126e7c4e5275 Luo bin 2020-07-15  132          int total_len_flag = 0;
> 5e126e7c4e5275 Luo bin 2020-07-15  133          int err;
> 5e126e7c4e5275 Luo bin 2020-07-15  134
> 5e126e7c4e5275 Luo bin 2020-07-15  135          fw_update_msg = kzalloc(sizeof(*fw_update_msg), GFP_KERNEL);
> 5e126e7c4e5275 Luo bin 2020-07-15  136          if (!fw_update_msg)
> 5e126e7c4e5275 Luo bin 2020-07-15  137                  return -ENOMEM;
> 5e126e7c4e5275 Luo bin 2020-07-15  138
> 5e126e7c4e5275 Luo bin 2020-07-15  139          up_total_len = host_image->image_info.up_total_len;
> 5e126e7c4e5275 Luo bin 2020-07-15  140
> 5e126e7c4e5275 Luo bin 2020-07-15  141          for (i = 0; i < host_image->section_type_num; i++) {
> 5e126e7c4e5275 Luo bin 2020-07-15  142                  len = host_image->image_section_info[i].fw_section_len;
> 5e126e7c4e5275 Luo bin 2020-07-15  143                  if (host_image->image_section_info[i].fw_section_type ==
> 5e126e7c4e5275 Luo bin 2020-07-15  144                      UP_FW_UPDATE_BOOT) {
> 5e126e7c4e5275 Luo bin 2020-07-15  145                          up_total_len = up_total_len - len;
> 5e126e7c4e5275 Luo bin 2020-07-15  146                          break;
> 5e126e7c4e5275 Luo bin 2020-07-15  147                  }
> 5e126e7c4e5275 Luo bin 2020-07-15  148          }
> 5e126e7c4e5275 Luo bin 2020-07-15  149
> 5e126e7c4e5275 Luo bin 2020-07-15  150          for (i = 0; i < host_image->section_type_num; i++) {
> 5e126e7c4e5275 Luo bin 2020-07-15  151                  section_len =
> 5e126e7c4e5275 Luo bin 2020-07-15  152                          host_image->image_section_info[i].fw_section_len;
> 5e126e7c4e5275 Luo bin 2020-07-15  153                  section_offset =
> 5e126e7c4e5275 Luo bin 2020-07-15  154                          host_image->image_section_info[i].fw_section_offset;
> 5e126e7c4e5275 Luo bin 2020-07-15  155                  section_remain_send_len = section_len;
> 5e126e7c4e5275 Luo bin 2020-07-15  156                  section_type =
> 5e126e7c4e5275 Luo bin 2020-07-15  157                          host_image->image_section_info[i].fw_section_type;
> 5e126e7c4e5275 Luo bin 2020-07-15  158                  section_crc = host_image->image_section_info[i].fw_section_crc;
> 5e126e7c4e5275 Luo bin 2020-07-15  159                  section_version =
> 5e126e7c4e5275 Luo bin 2020-07-15  160                          host_image->image_section_info[i].fw_section_version;
> 5e126e7c4e5275 Luo bin 2020-07-15  161
> 5e126e7c4e5275 Luo bin 2020-07-15  162                  if (section_type == UP_FW_UPDATE_BOOT)
> 5e126e7c4e5275 Luo bin 2020-07-15  163                          continue;
> 5e126e7c4e5275 Luo bin 2020-07-15  164
> 5e126e7c4e5275 Luo bin 2020-07-15  165                  send_fragment_len = 0;
> 5e126e7c4e5275 Luo bin 2020-07-15  166                  send_pos = 0;
> 5e126e7c4e5275 Luo bin 2020-07-15  167
> 5e126e7c4e5275 Luo bin 2020-07-15  168                  while (section_remain_send_len > 0) {
> 5e126e7c4e5275 Luo bin 2020-07-15  169                          if (!total_len_flag) {
> 5e126e7c4e5275 Luo bin 2020-07-15  170                                  fw_update_msg->total_len = up_total_len;
> 5e126e7c4e5275 Luo bin 2020-07-15  171                                  total_len_flag = 1;
> 5e126e7c4e5275 Luo bin 2020-07-15  172                          } else {
> 5e126e7c4e5275 Luo bin 2020-07-15  173                                  fw_update_msg->total_len = 0;
> 5e126e7c4e5275 Luo bin 2020-07-15  174                          }
> 5e126e7c4e5275 Luo bin 2020-07-15  175
> 5e126e7c4e5275 Luo bin 2020-07-15 @176                          memset(fw_update_msg->data, 0, MAX_FW_FRAGMENT_LEN);
> 5e126e7c4e5275 Luo bin 2020-07-15  177
> 5e126e7c4e5275 Luo bin 2020-07-15  178                          fw_update_msg->ctl_info.SF =
> 5e126e7c4e5275 Luo bin 2020-07-15  179                                  (section_remain_send_len == section_len) ?
> 5e126e7c4e5275 Luo bin 2020-07-15  180                                  true : false;
> 5e126e7c4e5275 Luo bin 2020-07-15  181                          fw_update_msg->section_info.FW_section_CRC = section_crc;
> 5e126e7c4e5275 Luo bin 2020-07-15  182                          fw_update_msg->fw_section_version = section_version;
> 5e126e7c4e5275 Luo bin 2020-07-15  183                          fw_update_msg->ctl_info.flag = UP_TYPE_A;
> 5e126e7c4e5275 Luo bin 2020-07-15  184
> 5e126e7c4e5275 Luo bin 2020-07-15  185                          if (section_type <= UP_FW_UPDATE_UP_DATA_B) {
> 5e126e7c4e5275 Luo bin 2020-07-15  186                                  fw_update_msg->section_info.FW_section_type =
> 5e126e7c4e5275 Luo bin 2020-07-15  187                                          (section_type % 2) ?
> 5e126e7c4e5275 Luo bin 2020-07-15  188                                          UP_FW_UPDATE_UP_DATA :
> 5e126e7c4e5275 Luo bin 2020-07-15  189                                          UP_FW_UPDATE_UP_TEXT;
> 5e126e7c4e5275 Luo bin 2020-07-15  190
> 5e126e7c4e5275 Luo bin 2020-07-15  191                                  fw_update_msg->ctl_info.flag = UP_TYPE_B;
> 5e126e7c4e5275 Luo bin 2020-07-15  192                                  if (section_type <= UP_FW_UPDATE_UP_DATA_A)
> 5e126e7c4e5275 Luo bin 2020-07-15  193                                          fw_update_msg->ctl_info.flag = UP_TYPE_A;
> 5e126e7c4e5275 Luo bin 2020-07-15  194                          } else {
> 5e126e7c4e5275 Luo bin 2020-07-15  195                                  fw_update_msg->section_info.FW_section_type =
> 5e126e7c4e5275 Luo bin 2020-07-15  196                                          section_type - 0x2;
> 5e126e7c4e5275 Luo bin 2020-07-15  197                          }
> 5e126e7c4e5275 Luo bin 2020-07-15  198
> 5e126e7c4e5275 Luo bin 2020-07-15  199                          fw_update_msg->setion_total_len = section_len;
> 5e126e7c4e5275 Luo bin 2020-07-15  200                          fw_update_msg->section_offset = send_pos;
> 5e126e7c4e5275 Luo bin 2020-07-15  201
> 5e126e7c4e5275 Luo bin 2020-07-15  202                          if (section_remain_send_len <= MAX_FW_FRAGMENT_LEN) {
> 5e126e7c4e5275 Luo bin 2020-07-15  203                                  fw_update_msg->ctl_info.SL = true;
> 5e126e7c4e5275 Luo bin 2020-07-15  204                                  fw_update_msg->ctl_info.fragment_len =
> 5e126e7c4e5275 Luo bin 2020-07-15  205                                          section_remain_send_len;
> 5e126e7c4e5275 Luo bin 2020-07-15  206                                  send_fragment_len += section_remain_send_len;
> 5e126e7c4e5275 Luo bin 2020-07-15  207                          } else {
> 5e126e7c4e5275 Luo bin 2020-07-15  208                                  fw_update_msg->ctl_info.SL = false;
> 5e126e7c4e5275 Luo bin 2020-07-15  209                                  fw_update_msg->ctl_info.fragment_len =
> 5e126e7c4e5275 Luo bin 2020-07-15  210                                          MAX_FW_FRAGMENT_LEN;
> 5e126e7c4e5275 Luo bin 2020-07-15  211                                  send_fragment_len += MAX_FW_FRAGMENT_LEN;
> 5e126e7c4e5275 Luo bin 2020-07-15  212                          }
> 5e126e7c4e5275 Luo bin 2020-07-15  213
> 5e126e7c4e5275 Luo bin 2020-07-15  214                          memcpy(fw_update_msg->data,
> 5e126e7c4e5275 Luo bin 2020-07-15  215                                 data + UPDATEFW_IMAGE_HEAD_SIZE +
> 5e126e7c4e5275 Luo bin 2020-07-15  216                                 section_offset + send_pos,
> 5e126e7c4e5275 Luo bin 2020-07-15  217                                 fw_update_msg->ctl_info.fragment_len);
> 5e126e7c4e5275 Luo bin 2020-07-15  218
> 5e126e7c4e5275 Luo bin 2020-07-15  219                          err = hinic_port_msg_cmd(priv->hwdev,
> 5e126e7c4e5275 Luo bin 2020-07-15  220                                                   HINIC_PORT_CMD_UPDATE_FW,
> 5e126e7c4e5275 Luo bin 2020-07-15  221                                                   fw_update_msg,
> 5e126e7c4e5275 Luo bin 2020-07-15  222                                                   sizeof(*fw_update_msg),
> 5e126e7c4e5275 Luo bin 2020-07-15  223                                                   fw_update_msg, &out_size);
> 5e126e7c4e5275 Luo bin 2020-07-15  224                          if (err || !out_size || fw_update_msg->status) {
> 5e126e7c4e5275 Luo bin 2020-07-15  225                                  dev_err(&priv->hwdev->hwif->pdev->dev, "Failed to update firmware, err: %d, status: 0x%x, out size: 0x%x\n",
> 5e126e7c4e5275 Luo bin 2020-07-15  226                                          err, fw_update_msg->status, out_size);
> 5e126e7c4e5275 Luo bin 2020-07-15  227                                  err = fw_update_msg->status ?
> 5e126e7c4e5275 Luo bin 2020-07-15  228                                          fw_update_msg->status : -EIO;
> 5e126e7c4e5275 Luo bin 2020-07-15  229                                  kfree(fw_update_msg);
> 5e126e7c4e5275 Luo bin 2020-07-15  230                                  return err;
> 5e126e7c4e5275 Luo bin 2020-07-15  231                          }
> 5e126e7c4e5275 Luo bin 2020-07-15  232
> 5e126e7c4e5275 Luo bin 2020-07-15  233                          send_pos = send_fragment_len;
> 5e126e7c4e5275 Luo bin 2020-07-15  234                          section_remain_send_len = section_len -
> 5e126e7c4e5275 Luo bin 2020-07-15  235                                                    send_fragment_len;
> 5e126e7c4e5275 Luo bin 2020-07-15  236                  }
> 5e126e7c4e5275 Luo bin 2020-07-15  237          }
> 5e126e7c4e5275 Luo bin 2020-07-15  238
> 5e126e7c4e5275 Luo bin 2020-07-15  239          kfree(fw_update_msg);
> 5e126e7c4e5275 Luo bin 2020-07-15  240
> 5e126e7c4e5275 Luo bin 2020-07-15  241          return 0;
> 5e126e7c4e5275 Luo bin 2020-07-15  242  }
> 5e126e7c4e5275 Luo bin 2020-07-15  243
>
> --
> 0-DAY CI Kernel Test Service
> https://urldefense.com/v3/__https://01.org/lkp__;!!BhJSzQqDqA!XYG2GtvZ6S2jfkp5Dd1G9i6xPhuBkvMuQWVEjV_rgLnKYvLVmow_TtmG3s5MYZMUnQBIKVk$
